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

### Password Scheme

Insure users create a good password by enforcing an expectation on the quality of the password using the libpam-cracklib PAM module. What follows is a description of the libpam-cracklib module, the various configuration settings that are available, and how those settings should be changed to insure high quality passwords.

#### Package Installation

Packages
* libpam-cracklib

#### Enabling pam_cracklib

The pam_cracklib module is enabled via the system's standard PAM configuration interface. This is the `/etc/pam.d/common-password` file . The typical configuration looks something like this:

```
password	requisite					pam_cracklib.so retry=3 minlen=8 difok=3
password	[success=1 default=ignore]	pam_unix.so obscure use_authtok try_first_pass sha512
```

The first line enables the `pam_cracklib` module and sets several module parameters. `retry=3` means that users get three chances to pick a good password before the `passwd` program aborts. Users can always re-run the `passwd` program and start over again, however. `minlen=8` sets the minimum number of characters in the password. `difok=3` sets the minimum number of characters that must be different from the previous password. If you increase `minlen`, you may also want to increase the `difok` value as well.

The second line invokes the standard `pam_unix` module. The `SHA512` argument here is what enables standard Linux SHA512 password hashes, though you have the option of using old-style DES56 hashes for backwards compatibility with legacy Unix systems. `use_authtok` tells pam_unix to not bother doing any of its own internal password checks, which duplicate many of the checks in `pam_cracklib`, but instead accept the password that the user inputs after it's been thoroughly checked by `pam_cracklib`.

Edit the `/etc/pam.d/common-password` file and make the following changes to improve the default security:
* Change the pam_cracklib.so line to match the one below:

```
password	requisite	pam_cracklib.so retry=3 minlen=8 difok=4 lcredit=-1 ucredit=-1 dcredit=-1 ocredit=-2
```

Account password policy is as follows:
* Minimum password length of 8 characters. (minlen)
* At least 4 characters in the new password which must not also be in the old password. (difok)
* At least one lower-case character. (lcredit)
* At least one upper-case character. (ucredit)
* At least one digit character. (dcredit)
* At least two non-alphanumeric characters. (ocredit)

The `minlen` value is actually the minimum required length for a password consisting of all lower-case letters. But users get `length credits` for using upper- and lower-case letters, numbers, and non-alphanumeric characters. The default is normally that you can only get a maximum of `1 credit` for each type of character. So if the administrator sets `minlen=12`, a user could still have an 8 character password if they used all four types of characters. Actually, since using a lower-case letter gets you a credit, the real minimum length for an all lower-case password is minlen-1. The maximum credit for any particular class of characters is actually customizable. The four parameters `lcredit`, `ucredit`, `dcredit`, and `ocredit` are used to set the maximum credit for lower-case, upper-case, numeric (digit), and non-alphanumeric (other) characters, respectively. However, when the values for these four parameters is set to a negative number, then the user receives no credit for using that type of character. Rather, they are required to use that type of character the number of times given be the negative number. Therefore, if the value is `-1`, then at least one of that type of character must be used in the password.

Edit the `/etc/pam.d/common-password` file and make the following changes to improve the default security:
* Change the pam_unix.so line, and add the following as the end:

```
remember=400
```

The value of the `remember` parameter is the number of old passwords you want to store for a user. It turns out that there's an internal maximum of 400 previous passwords, so values higher than 400 are all equivalent to 400. Before you complain about this limit, consider that even if your site forces users to change passwords every 30 days, 400 previous passwords represents over 30 years of password history. This is probably sufficient for even the oldest of legacy systems.
