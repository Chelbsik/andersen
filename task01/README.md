TASK 01
-------------------------------------------------------------------------
one_liner.sh

- Takes process name or ID entered by the user.
- Finds out five addresses with the most connection dublicates.
- Collect some information about organizations that owns the addresses.

UPDATED 07.03.2021:

- Script can take Procces name/ID as parameter
- Check if requested connection exists, and ask user confirmation 
-------------------------------------------------------------------------
one_liner_v2.sh

- Does all the same, but with ss and sed implementations.

UPDATED 07.03.2021:

- Now script can accept parameter and use it as utility to gather connection data. Only "netstat" (default) and "ss" (if there is no netstat, or if ss parameter is specified). 
-------------------------------------------------------------------------

