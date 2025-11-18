function payrix-s3xfer --description="Copy file from remote host to secure s3 staging with built fetching command"
    set -l secret_name_prefix pci-transfer-key
    set -l bucket_name payrix-pci-transfer-staging
    set -l aws_region us-east-1
    set -l remote_host payrix-jobs-dev

    if test (count $argv) -ne 1
        echo "Usage: upload_encrypted_to_s3 <filename>" >&2
        return 1
    end

    set -l filename $argv[1]
    set -l basename (basename "$filename")
    set -l secret_name "$secret_name_prefix-$basename"
    set -l s3_object_name "$basename.gpg"

    # Generate passphrase locally
    set -l passphrase_file (mktemp)
    openssl rand -base64 32 >"$passphrase_file"

    # Temp file for the passphrase ON REMOTE
    echo "Creating remote temp file for passphrase..."
    set -l remote_passphrase_file (ssh "$remote_host" "mktemp")

    # Copy passphrase file up
    echo "Uploading passphrase to remote temp file..."
    scp "$passphrase_file" "$remote_host:$remote_passphrase_file"

    # Validate filename safety
    if not string match -rq '^[-./A-Za-z0-9_]+$' -- $filename
        echo "Error: filename contains unsafe characters: $filename" >&2
        return 1
    end

    # Encrypt + upload remotely
    echo "Encrypting and uploading on remote host..."
    ssh "$remote_host" "
    sudo cat '$filename' | \
    gpg --batch --yes --passphrase-file '$remote_passphrase_file' -c --output - | \
    aws s3 cp - 's3://$bucket_name/$s3_object_name' --sse AES256 --acl private --region '$aws_region'
"

    # (optional) Clean up remote passphrase file
    echo "Cleaning up remote passphrase file..."
    ssh "$remote_host" "rm '$remote_passphrase_file'"

    # Locally upload passphrase to Secrets Manager
    echo "Uploading secret to AWS Secrets Manager..."
    aws secretsmanager put-secret-value --secret-id "$secret_name" \
        --secret-string (cat "$passphrase_file") --region "$aws_region"

    # POSIX decryption command output
    echo
    echo "File uploaded successfully."
    echo "To download and decrypt, run:"
    echo

    set -l output_filename (string replace -r '\.gpg$' '' -- $basename)

    printf "%s\n" "PASSPHRASE_FILE=\$(mktemp) && aws secretsmanager get-secret-value --secret-id \"$secret_name\" --region \"$aws_region\" --query 'SecretString' --output text > \"\$PASSPHRASE_FILE\" && aws s3 cp \"s3://$bucket_name/$s3_object_name\" - --region \"$aws_region\" | gpg --batch --yes --passphrase-file \"\$PASSPHRASE_FILE\" -o \"$output_filename\" && rm \"\$PASSPHRASE_FILE\""

    echo
end
