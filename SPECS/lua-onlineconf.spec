%define _lualibdir %{?el5:%{_libdir}}%{?!el5:%{_datadir}}/lua/5.1
Name: lua-onlineconf
Version: 1.3
Release: 1%{?dist}
Summary: lua onlineconf client
License: MIT
Group: Development/Libraries
BuildArch: noarch
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-buildroot
URL: https://github.com/onlineconf/onlineconf-lua
Source: https://github.com/onlineconf/onlineconf-lua/archive/v%{version}.tar.gz
Requires: lua >= 5.1.4
Requires: lua-posix
Requires: lua-cjson

%description
Simple lua onlineconf client. Only modules support.

%prep
%setup -q -n onlineconf-lua-%{version}

%install
%__rm -rf %{buildroot}
%__install -pD -m 644 lua/onlineconf.lua %{buildroot}%{_lualibdir}/onlineconf.lua

%clean
[ "%{buildroot}" != "/" ] && %__rm -fr %{buildroot}

%files
%{_lualibdir}/onlineconf.lua

%changelog
* Tue Oct 22 2019 Sergey Panteleev <panteleev@corp.mail.ru>
- rewrite spec file
* Tue May  6 2014 Sergey Panteleev <panteleev@corp.mail.ru>
- Initial version
