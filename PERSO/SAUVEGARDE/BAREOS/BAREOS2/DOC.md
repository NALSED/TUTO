| Élément                | Définition |
|-------------------------|-------------|
| `<week-keyword>`         | 1st \| 2nd \| 3rd \| 4th \| 5th \| first \| second \| third \| fourth \| fifth \| last |
| `<wday-keyword>`         | sun \| mon \| tue \| wed \| thu \| fri \| sat \| sunday \| monday \| tuesday \| wednesday \| thursday \| friday \| saturday |
| `<week-of-year-keyword>` | w00 \| w01 \| ... \| w52 \| w53 |
| `<month-keyword>`        | jan \| feb \| mar \| apr \| may \| jun \| jul \| aug \| sep \| oct \| nov \| dec \| january \| february \| ... \| december |
| `<digit>`                | 0 \| 1 \| 2 \| 3 \| 4 \| 5 \| 6 \| 7 \| 8 \| 9 |
| `<number>`               | `<digit>` \| `<digit><number>` |
| `<12hour>`               | 0 \| 1 \| 2 \| ... \| 12 |
| `<hour>`                 | 0 \| 1 \| 2 \| ... \| 23 |
| `<minute>`               | 0 \| 1 \| 2 \| ... \| 59 |
| `<day>`                  | 1 \| 2 \| ... \| 31 |
| `<time>`                 | `<hour>:<minute>` \| `<12hour>:<minute>am` \| `<12hour>:<minute>pm` |
| `<time-spec>`            | at `<time>` \| hourly |
| `<day-range>`            | `<day>`-`<day>` |
| `<month-range>`          | `<month-keyword>`-`<month-keyword>` |
| `<wday-range>`           | `<wday-keyword>`-`<wday-keyword>` |
| `<range>`                | `<day-range>` \| `<month-range>` \| `<wday-range>` |
| `<modulo>`               | `<day>`/`<day>` \| `<week-of-year-keyword>`/`<week-of-year-keyword>` |
| `<date>`                 | `<date-keyword>` \| `<day>` \| `<range>` |
| `<date-spec>`            | `<date>` \| `<date-spec>` |
| `<day-spec>`             | `<day>` \| `<wday-keyword>` \| `<wday-range>` \| `<week-keyword> <wday-keyword>` \| `<week-keyword> <wday-range>` \| daily |
| `<month-spec>`           | `<month-keyword>` \| `<month-range>` \| monthly |
| `<date-time-spec>`       | `<month-spec>` `<day-spec>` `<time-spec>` |
