### [JQ](https://stedolan.github.io/jq/manual/)

#### Pretty Print
```
echo {JSON} | jq '.'
```

#### Select attribute
```
echo {JSON} | jq '.attr'
```

#### Select array values (`[n]` `[n:m]` `[:n]` `[n:]`)
```
echo {JSON} | jq '.arrayAttr | .[0] | .subArrayAttr | .[0]'
```

## Arrays

#### Array Map / Filter
```
echo '[{ "k": "AAA", "v": 10 }, { "k": "BBB", "v": 99 }]' | jq 'map({ key: .n, value: .k })'
echo '[{"k1": "v1"}, {"k1": "v2"}]' | jq 'map(.k1)'
echo '[{"k1": "v1"}, {"k1": "v2"}]' | jq 'map(select(.k1 == "v1"))'
```

#### Array Length
```
echo '[1, 2]' | jq 'length'
Gets the length of the array.
```

#### Array Reverse
```
echo '[1, 2]' | jq 'reverse'
```

#### Array Add
```
echo '[1, 2]' | jq 'add'
```

#### Array Constructor
```
echo '[1, 2, 3]' | jq '[.[0], .[2]]'
```

#### Flatten (from a list of lists to a single list)
```
echo '[[1], [2]]' | jq 'flatten'
```

## Objects

#### Object COnstructor
```
echo '[1, 2, 3]' | jq '{k1: .[0], k2: .[2]}'
```

#### Get Keys
```
echo '{"k1": "v1", "k2": "v2"}' | jq 'keys'
```

#### Object to Array of K/V pairs
```
echo '{"k1": "v1", "k2": "v2"}' | jq 'to_entries'
```

#### Array of K/V pairs to Object
```
echo '[{"key":"k1","value":"v1"},{"key":"k2","value":"v2"}]' | jq 'from_entries'
```

## Options

#### Multiple values into a single array (-s)
```
echo '[][]' | jq -s '.'
```

#### Array to multiple results (.[], multiline)
```
echo '[1, 2, 3]' | jq '.[]'
```

#### Quoted json to raw string (-r, "name" => name)
```
echo '0' | jq -r '"f"'
```

#### STDIN as json strings delimited by newlines (-R)
```
echo 'string' | jq -R '.'
```

## Examples

#### Reading newline delimited data
> we cannot use slurp and raw string input together. If we do, jq parses the entire input as a single raw string. We need to call jq twice.
```
echo -e "string\nstring" | jq -R '.' | jq -s '.'
```

#### Output an array of numbers as newline delimited numbers
```
echo '0' | jq '[1, 2, 3] | .[]'
```

#### Output an array of strings as newline delimited strings
```
echo '0' | jq -r '["a", "b", "c"] | .[]'
```
