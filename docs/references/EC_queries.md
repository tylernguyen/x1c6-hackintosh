## Battery

### _Q22

### _Q4A
/* Battery 0 attach/detach */

Method(_Q4A, 0, NotSerialized)
{
	Notify(BAT0, 0x81)
}

### _Q4B
/* Battery 0 state change */
```
Method(_Q4B, 0, NotSerialized)
{
	Notify(BAT0, 0x80)
}
```

###  _Q4C
/* Battery 1 attach/detach */
```
Method(_Q4C, 0, NotSerialized)
{
	Notify(BAT1, 0x81)
}
```

### _Q4D
/* Battery 1 state change */
```
Method(_Q4D, 0, NotSerialized)
{
	Notify(BAT1, 0x80)
}
```

### _Q24
Battery 0 critical 
```
Notify(BAT0, 0x80)
```

### _Q25
Battery 1 critical 
```
Notify(BAT1, 0x80)
```

## Power

| Event                         | EC Query |   |
|-------------------------------|----------|---|
| Lid Open                      | _Q2A     |   |
| Lid Close                     | _Q2B     |   |
| Sleep Button                  | _Q13     |   |
| AC Status Change: Present     | _Q26     |   |
| AC Status Change: Not Present | _Q27     |   |

## Misc

### _Q1C

### _Q1D

## Sleep?

### _Q62

### _Q65


### _Q3D

### _Q48

### _Q49

### _Q7F

### _Q46

### _Q3B

### _Q4F

### _Q2F