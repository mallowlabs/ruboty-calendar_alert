# Ruboty::CalendarAlert
Mount alerting system to [Ruboty]("https://github.com/r7kamura/ruboty") to notify calendar schedules with iCal urls.

## Usage
See below commands. You can use any iCal urls.

```
@ruboty add calendar <ics_url>    - Add an alerting calendar
@ruboty delete calendar <ics_url> - Delete an alerting calendar
@ruboty list calendars             - List all alerting calendars
```

## Fetching behavior
```ruboty-calendar_alert``` fetches calendar data on below times.

 * 02:23
 * 08:23
 * 14:23
 * 20:23

So new schedules may not be alerted.
If you are in a harry, use ```add calendar``` command with same iCal url.

```list calendars``` command shows only schedules which start in 24 hours.

## Credits

This plugin reuses codes of [ruboty-cron](https://github.com/r7kamura/ruboty-cron/). Many thanks to [r7kamura](https://github.com/r7kamura/).


