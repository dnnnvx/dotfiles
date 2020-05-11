# Scripting
[source](https://dev.to/godcrampy/the-missing-shell-scripting-crash-course-37mk)

## First of all
`#!/bin/env bash`

## Get a prompt value
```bash
read -p "What's your name? " name
echo "Hello, $name"
```

## Get arguments
```bash
echo $0 # this is "./start.sh"
echo $1
echo $2
echo "${@}" # Access all the arguments
# Iterating over arguments
# @ holds all the arguments passed in to the script
for i in "$@"
do
  echo "$i"
done
```

## Variable Length / Exist
```bash
[[ -e "$file" ]] # True if file exists
[[ -d "$file" ]] # True if file exists and is a directory
[[ -f "$file" ]] # True if file exists and is a regular file
[[ -z "$str" ]]  # True if string is of length zero
[[ -n "$str" ]]  # True is string is not of length zero
```

## Compare Strings
```bash
[[ "$str1" == "$str2" ]]
[[ "$str1" != "$str2" ]]
```

## Integer Comparisions
```bash
[[ "$int1" -eq "$int2" ]] # $int1 == $int2
[[ "$int1" -ne "$int2" ]] # $int1 != $int2
[[ "$int1" -gt "$int2" ]] # $int1 > $int2
[[ "$int1" -lt "$int2" ]] # $int1 < $int2
[[ "$int1" -ge "$int2" ]] # $int1 >= $int2
[[ "$int1" -le "$int2" ]] # $int1 <= $int2
```

## And / Or
```bash
[[ ... ]] && [[ ... ]] # And
[[ ... ]] || [[ ... ]] # Or
```


## Return values
```bash
# If notes.md file doesn't exist, create one and 
# add the text "created by bash"
if find notes.md
then
  echo "notes.md file already exists"
else
  echo "created by bash" | cat >> notes.md
fi
```

## Arithmetic Evaluations
```bash
read -p "Enter your age: " age
if (( "$age" > 18 ))
then
  echo "Adult!"
elif (( "$age" > 12 ))
then
  echo "Teen!"
else
  echo "Kid"
fi
```

## Test Expressions
```bash
# Check if argument was passed
# "$1" corresponds to first argument
if [[ -n "$1" ]]
then
  echo "Your first argument was $1"
else
  echo "No Arguments passed"
fi
```

## Loops
```bash
# c like for loop
for (( i = 1; i <= 10; ++i ))
do
  echo "$i"
done

# for in
for i in {1..10}
do
  echo "$i"
done

# while
i=1
while [[ "$i" -le 10 ]]
do
  echo "$i"
  ((i++))
done

# until
i=1
until [[ "$i" -eq 11 ]]
do
  echo "unitl $i"
  ((i++))
done
```

# Arrays
```bash
# Arrays are declared using parenthesis without commas between elements.
# ${#arr[@]} returns the length of the array.
arr=(a b c d)

echo "${arr[1]}"     # Single element
echo "${arr[-1]}"    # Last element
echo "${arr[@]:1}"   # Elements from 1
echo "${arr[@]:1:3}" # Elements from 1 to 3

arr[5]=e # direct address and insert/update
arr=(${arr[@]:0:1} new ${arr[@]:1}) # Adding 'new' to array

unset arr[1] # delete
arr=("${arr[@]}") # Once removing is done, we need to re-index the array.

# For in (arguments)
for i in "${arr[@]}"
do
  echo "$i"
done

# c like for
for (( i = 0; i < "${#arr[@]}"; i++))
do
  echo "${arr[$i]}"
done

# while
i=0
while [[ "$i" -le "${#arr[@]}" ]]
do
  echo "${arr[$i]}"
  (( i++ ))
done
```

## Functions
```bash
greet() {
  echo "Hello, $1"
}
greet Marco # Hello, Marco

greetEveryone() {
  echo "Hello, ${@}"
}
greetEveryone every single body # Hello, every single body
```

## Strip
```bash
# Strip variable informations (file extensions, ...)
A=abc123foo.txt
# strip suffix:
echo ${A%.txt} # abc123foo
# strip suffix with globbing:
echo ${A%foo*} # abc123
# strip prefix:
echo ${A#abc} # 123foo.txt
# strip prefix with globbing:
echo ${A#*c} # 123foo.txt
```