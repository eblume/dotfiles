function payrix-times --description="Print relevant time information for payrix"
    set -l tz (python -c 'import pytz; print(pytz.timezone("America/Los_Angeles").localize(pytz.datetime.datetime.now()).tzname())')
    set -l offset (python -c 'import pytz; print(int(pytz.timezone("America/Los_Angeles").localize(pytz.datetime.datetime.now()).utcoffset().total_seconds() / 3600))')
    echo "Current timezone: $tz (UTC$(printf %+03d $offset))"
    set -l dc_time (TZ='America/New_York' date +"%Y-%m-%d %H:%M:%S %Z")
    set -l budapest_time (TZ='Europe/Budapest' date +"%Y-%m-%d %H:%M:%S %Z")
    set -l austin_time (TZ='America/Chicago' date +"%Y-%m-%d %H:%M:%S %Z")
    set -l la_time (TZ='America/Los_Angeles' date +"%Y-%m-%d %H:%M:%S %Z")
    set -l utc_time (date -u +"%Y-%m-%d %H:%M:%S UTC")
    echo "Current time in Washington DC: $dc_time"
    echo "Current time in Budapest, Hungary: $budapest_time"
    echo "Current time in Austin, TX: $austin_time"
    echo "Current time in Los Angeles, CA: $la_time"
    echo "Current time in UTC: $utc_time"
end
