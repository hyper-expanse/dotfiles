# Security Hardening

Hardening a system is an important process to conduct for all newly provisioned systems along with existing in-production systems to insure that information is secured and services can be provided in a continuous and reliable manner.

This configuration guide walks through the process of securing a standard Debian installation by installing various security tools, instituting "best practice" changes to the default settings of pre-installed services, and insuring the latest protocols are utilized. This guide, however, does not guarantee that a system is impervious to a security breach, nor does it account for the human factor in system security. Rather, it simply looks at implementing the best standard of security on a system while leaving the maintenance of security to institutional policies.

## Account Security

Account security involves the creation and management of user accounts on a system in a manner that insures the security and integrity of that system. Account security has two aspects which must be handled; first, protecting the access to accounts on a system, and second, insuring that an account is used in a manner that is appropriate given institutional policies.

### Password Expiration

When new accounts are created on a system, the defaults for those accounts are pulled from `/etc/login.defs`. Those defaults include options for password expiration, and accounts expiration. These options must be changed to improve the standard security afforded by the default password expiration options.

Edit the following file, `/etc/login.defs`, and change the options so that they look like those below:
* `PASS_MAX_DAYS` is how often users must change their passwords.
	* `PASS_MAX_DAYS 180`
* `PASS_MIN_DAYS` is how long a user is forced to live with their new password before their allowed to change it again.
	* `PASS_MIN_DAYS 1`
* `PASS_WARN_AGE` is the number of days before the password expiration date that the user is warned that their password is about to expire.
	* `PASS_WARN_AGE 7`
* `LOGIN_RETRIES` is the number of attempts a user has to enter their password before the account is locked. Once an account is locked, it can only be unlocked by an administrator.
	* `LOGIN_RETRIES 5`
* `ENCRYPT_METHOD` is the method used to encrypt the user's password.
	* `ENCRYPT_METHOD SHA512`

Edit the following file, `/etc/default/useradd`, uncomment the following line and insure the line looks like the one below:

```
INACTIVE=10
```

Meaning of each value:
* `PASS_MAX_DAYS`: Passwords must expire after 180 days, thereby requiring a new password to be set.
* `PASS_MIN_DAYS`: Passwords may be changed only once per day at most as indicated by the 1 days between changes.
* `PASS_WARN_AGE`: A password expiration warning should be given each time a user logs into their account, beginning 7 days prior to the expiration date.
* `LOGIN_RETRIES`: Number of attempts a user has to enter their password before the account is locked. Once an account is locked, it can only be unlocked by an administrator.
* `ENCRYPT_METHOD`: The has algorithm used to encrypt the user's password for storage into the in-system password database.
* `INACTIVE`: Accounts should be locked as a result of inactivity 10 days after the password expires. This action requires an administrator to re-activate the account.

To look at the current state of a user's password expiration information:

```
sudo chage -l [USERNAME]
```

Change the state of each existing user's password expiration information:

```
sudo chage [USERNAME]
```
