# Browser

## Extensions

A list of useful browser extensions:

- Disable WebRTC
- HTTPS Everywhere
- Privacy Badger
- Sourcegraph
- uBlock Origin
- Vue.js devtools

## Firefox Options

### Universal 2nd Factor

[Universal 2nd Factory](https://en.wikipedia.org/wiki/Universal_2nd_Factor) based authentication is not enabled by default in Firefox. Therefore, you can't use U2F devices, such as Yubikeys, to authenticate with websites.

To turn on U2F in Firefox, please do the following:

1. Navigate to `about:config`.
1. Search for `security.webauth.u2f`.
1. Double click on `security.webauth.u2f` to change it's value to `true`.
