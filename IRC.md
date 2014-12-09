# IRC

## Freenode

[Using the Network](https://freenode.net/using_the_network.shtml) is a guide on interacting with Freenode.

### User Mode

```
/mode hbetts +QRi
```

## Useful Commands

### Channel Modes

```
/mode [CHANNEL] +nt
```

### Query

Open a private "query" window with the designated user.

```
/query [NICK]
```

Close the current "query" window.

```
/query
```

## Managing User Accounts

### NickServ

```
/msg NickServ SET HIDEMAIL ON
/msg NickServ SET NEVEROP ON
/msg NickServ SET ENFORCE ON
/msg NickServ SET PRIVATE ON
```

Register addition nicks with an existing account:

```
/nick [NICK]
/msg NickServ group
```
