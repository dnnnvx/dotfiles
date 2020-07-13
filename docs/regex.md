# RegEx
[source](https://refrf.shreyasminocha.me/)
[Awesome List](https://github.com/aloisdg/awesome-regex)

#### Javascript comments
```
/\/\*[\s\S]*?\*\/|\/\/.*/g
```
- const a = 0; **// comment**
- **/\* multiline \*/**

#### 24-Hour Time
```
/^([01]?[0-9]|2[0-3]):[0-5][0-9](:[0-5][0-9])?$/g
```
- **23:59:00**
- **14:00**
- **23:00**
- 29:00
- 32:32

#### Meta

```
/<Example source="(.*?)" flags="(.*?)">/gm
```
- **`<Example source="p[aeiou]t" flags="g">`**
- **`<Example source="s+$" flags="gm">`**
- **`<Example source="(['"])(?:(?!\1).)*\1" flags="g">`**
- `<Example source='s+$' flags='gm'>`
- `</Example>`

#### Floating point numbers
(optional sign, optional integer part, optional decimal part, optional exponent part)
```
/^([+-]?(?=\.\d|\d)(?:\d+)?(?:\.?\d*))(?:[eE]([+-]?\d+))?
```
- **987**
- **-8**
- **0.1**
- **2.**
- **.987**
- **+4.0**
- **1.1e+1**
- **1.e+1**
- **1e2**
- **0.2e2**
- **.987e2**
- **+4e-1**
- **-8.e+2**

#### Latitude and Longitude

```
/^((-?|\+?)?\d+(\.\d+)?),\s*((-?|\+?)?\d+(\.\d+)?)$/g
```
- **30.0260736, -89.9766792**
- **45, 180**
- **-90.000, -180.0**
- **48.858093,2.294694**
- **-3.14, 3.14**
- **045, 180.0**
- **0,    0**
- -90., -180.
- .004, .15

#### MAC Addresses
```
/^[a-f0-9]{2}(:[a-f0-9]{2}){5}$/i
```
- **01:02:03:04:ab:cd**
- **9E:39:23:85:D8:C2**
- **00:00:00:00:00:00**
- 1N:VA:L1:DA:DD:R5
- 9:3:23:85:D8:C2
- ac::23:85:D8:C2

#### UUID
```
/[\da-f]{8}-([\da-f]{4}-){3}[\da-f]{12}/i
```
- **123e4567-e89b-12d3-a456-426655440000**
- **c73bcdcc-2669-4bf6-81d3-e4ae73fb11fd**
- **C73BCDCC-2669-4Bf6-81d3-E4AE73FB11FD**
- c73bcdcc-2669-4bf6-81d3-e4an73fb11fd
- c73bcdcc26694bf681d3e4ae73fb11fd

#### IP Addresses
```
/\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\b/g
```
- **9.9.9.9**
- **127.0.0.1**:8080
- It's **192.168.1.9**
- **255.193.09.243**
- **123.123.123.123**
- 123.123.123.256
- 0.0.x.0

#### HSL colours
Integers from 0 to 360
- 360
- 300 to 359 — 3, [0 - 5], any digit
- 0 to 299 (optionally 1 or 2 as the hundreds digit, optionally any tens digit, a units digit)
```
/^0*(?:360|3[0-5]\d|[12]?\d?\d)$/g
```
- **360**
- **349**
- **235**
- **152**
- **68**
- **9**
- 361
- 404

#### Percentages
```
/^(?:100(?:\.0+)?|\d?\d(?:\.\d+)?)%$/g
```
- **100%**
- **100.0%**
- **25%**
- **52.32%**
- **9%**
- **0.5%**
- 100.5%
- 42