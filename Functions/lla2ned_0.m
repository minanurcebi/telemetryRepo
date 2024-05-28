function llaNED = lla2ned_0(lla, lla0, method)
% MATLAB 2021a sürümünde eklenen lla2ned fonksiyonun işlevini önceki
% sürümlerde de kullanabilmek için geliştirilmiş bir fonksiyondur.  Temelde
% aynı işi ilk önce ECEF koordinat sistemine aktararak yapmaktadır.
% lla2ecef ve lla2flat fonksiyonları kullanılmaktadır.
%
% llaNED = lla2ned_0(lla, lla0, method)
%
% lla0:   NED koordinat sisteminin merkezinin LLA koordinatları, [lat, lon,
%         alt], açılar derece, yükseklik m olarak.
% lla:    NED eksen takımına aktarılacak olan noktanın LLA koordinatları.
% method: 'flat' veya 'ellipsoid'.  Varsayılan ellipsoid.
% llaNED: lla noktasının, lla0 noktasında tanımlı NED eksen takımındaki
%         koordinatları.
%
% Buradaki latitude ve longitude değerleri derece cinsinden  WGS84 Dünya
% modeline göre olan geodetic koordinatlarıdır.  Altitude ise WGS84
% elipsoidine göre yükseklik değeridir.
%
% 2023.12.29 Ali Türker Kutay
% atkutay@gmail.com

% Method tanımlı değilse ellipsoid olarak ayarla
if nargin == 2
    method = "ellipsoid";
end

if method == "ellipsoid"
    % İlk önce her iki noktayı da ECEF koordinat sistemine aktaralım:
    lla0Ecef = lla2ecef(lla0);
    llaEcef = lla2ecef(lla);

    % lla noktasının lla0 noktasına göre konumu, ECEF koordinat sisteminde:
    P = (llaEcef - lla0Ecef)';
    % Daha sonra ECEF ve NED eksek takımları arasındaki dönüşüm matrisini
    % oluşturalım:
    mu0 = lla0(1)*pi/180;
    l0 = lla0(2)*pi/180;
    T_ECEF_NED = [-sin(mu0)*cos(l0) -sin(l0) -cos(mu0)*cos(l0)
        -sin(mu0)*sin(l0) cos(l0) -cos(mu0)*sin(l0)
        cos(mu0) 0 -sin(mu0)];

    llaNED = T_ECEF_NED'*P;

    % MATLAB'deki fonksiyonlar konum vektörlerini kolon değil de sıra olarak
    % alıyor o yüzden sıra olacak şekilde transpose'unu alalım:
    llaNED = llaNED';
elseif method == "flat"
    llaNED = lla2flat(lla,lla0(1:2),0,-lla0(3));
else
    error('Fonksiyonun üçüncü girdisi method ya "flat" ya da "ellipsoid" olmalı')
end