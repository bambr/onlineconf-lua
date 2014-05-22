Name: lua-onlineconf
Version: 1.0
Release: 1%{?dist}
Summary: lua onlineconf client
License: MIT
Group: Development/Libraries
BuildArch: noarch
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-buildroot
Source0: onlineconf.lua
Requires: lua >= 5.1.4
Requires: lua-posix
Requires: lua-cjson

%description
Simple lua onlineconf client. Only modules support.

%install
%__rm -rf %{buildroot}
%__install -pD -m 644 %{SOURCE0} %{buildroot}%{_prefix}/lib/lua/5.1/onlineconf.lua

%clean
[ "%{buildroot}" != "/" ] && %__rm -fr %{buildroot}

%files
%{_prefix}/lib/lua/5.1/onlineconf.lua

%changelog
* Tue May  6 2014 Sergey Panteleev <panteleev@corp.mail.ru>
- Initial version
