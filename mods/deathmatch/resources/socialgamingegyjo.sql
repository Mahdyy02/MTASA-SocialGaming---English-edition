-- phpMyAdmin SQL Dump
-- version 5.0.1
-- https://www.phpmyadmin.net/
--
-- Gép: 127.0.0.1
-- Létrehozás ideje: 2020. Már 30. 13:43
-- Kiszolgáló verziója: 10.4.11-MariaDB
-- PHP verzió: 7.4.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Adatbázis: `socialgamingegyjo`
--

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `accounts`
--

CREATE TABLE `accounts` (
  `id` int(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `serial` varchar(255) NOT NULL,
  `ip` varchar(255) NOT NULL,
  `registerdatum` date NOT NULL,
  `lastlogin` date NOT NULL,
  `online` int(11) NOT NULL,
  `banDatas` varchar(1000) CHARACTER SET utf8mb4 NOT NULL DEFAULT '[ false ]',
  `banEnd` date DEFAULT '0000-00-00'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- A tábla adatainak kiíratása `accounts`
--

INSERT INTO `accounts` (`id`, `name`, `password`, `email`, `serial`, `ip`, `registerdatum`, `lastlogin`, `online`, `banDatas`, `banEnd`) VALUES
(8, 'Zorty', 'DFC31A131ED06A916C16D53C9E8329D0ED0B1F6B374E469E664FC1D63BB02422', 'nemkapodmeg@gmail.com', '29AF24F8EA1706C99DCF857F6067E4F2', '192.168.56.1', '2020-03-30', '2020-03-30', 0, '[ false ]', '0000-00-00');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `actionbar`
--

CREATE TABLE `actionbar` (
  `dbid` int(11) NOT NULL,
  `playerID` int(11) NOT NULL,
  `slots` varchar(1000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `atmek`
--

CREATE TABLE `atmek` (
  `id` int(11) NOT NULL,
  `pos` varchar(2000) NOT NULL,
  `rob` int(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- A tábla adatainak kiíratása `atmek`
--

INSERT INTO `atmek` (`id`, `pos`, `rob`) VALUES
(11, '[ [ 1173.22265625, -1341.5400390625, 13.69393272399902, 0, 0, 451.0560913085938 ] ]', 0),
(13, '[ [ 1553.822265625, -1667.79296875, 13.25582427978516, 0, 0, 269.7624206542969 ] ]', 0),
(14, '[ [ 1420.638671875, -1677.435546875, 13.246875, 0, 0, 448.7763671875 ] ]', 0),
(16, '[ [ 2162.07421875, -2165.8427734375, 13.246875, 0, 0, 221.6855163574219 ] ]', 0),
(19, '[ [ 1480.205078125, -1767.3486328125, 13.246875, 0, 0, 509.1471862792969 ] ]', 0),
(26, '[ [ 1366.455078125, -1273.6943359375, 13.246875, 0, 0, 358.9617919921875 ] ]', 0),
(29, '[ [ 999.4833984375, -923.21484375, 41.88689727783203, 0, 0, 276.1455688476562 ] ]', 0),
(30, '[ [ -2420.1513671875, 971.8095703125, 44.996875, 0, 0, 450.8638305664062 ] ]', 0),
(31, '[ [ 2105.4580078125, -1805.2060546875, 13.2546875, 0, 0, 269.2295837402344 ] ]', 0),
(32, '[ [ 2133.3095703125, -1151.3212890625, 23.77721519470215, 0, 0, 537.3440246582031 ] ]', 0),
(34, '[ [ 1212.9306640625, -1812.345703125, 16.29375, 0, 0, 449.5619201660156 ] ]', 0),
(36, '[ [ 1810.578125, -1925.212890625, 13.25513095855713, 0, 0, 272.201416015625 ] ]', 0),
(37, '[ [ 2719.4453125, -2417.5400390625, 13.32901592254639, 0, 0, 187.1769409179688 ] ]', 0),
(39, '[ [ 2022.6630859375, -1401.6748046875, 16.8851921081543, 0, 0, 358.2916259765625 ] ]', 0),
(44, '[ [ 1861.466796875, -1368.14453125, 13.25651378631592, 0, 0, 271.805908203125 ] ]', 0),
(48, '[ [ 1502.7392578125, -686.1416015625, 94.45, 0, 0, 365.1526641845703 ] ]', 0),
(50, '[ [ 1411.9169921875, -2205.0556640625, 13.23907012939453, 0, 0, 355.9130249023438 ] ]', 0),
(51, '[ [ 1310.4609375, 1.1796875, 1002.1921875, 649, 18, 271.1247253417969 ] ]', 0),
(52, '[ [ 849.1728515625, -1063.056640625, 24.80679626464844, 0, 0, 391.7015228271484 ] ]', 0),
(53, '[ [ 302.7646484375, -1156.1416015625, 80.60989685058594, 0, 0, 315.4387512207031 ] ]', 0),
(55, '[ [ -280.490234375, -2175.6162109375, 28.34317321777344, 0, 0, 295.3609619140625 ] ]', 0),
(57, '[ [ 1976.642578125, -2049.025390625, 13.24645824432373, 0, 0, 270.9599609375 ] ]', 0),
(59, '[ [ 2824.345703125, -1593.8291015625, 10.80177230834961, 0, 0, 513.9427795410156 ] ]', 0),
(60, '[ [ 2098.5380859375, -1359.5166015625, 23.684375, 0, 0, 355.2208862304688 ] ]', 0),
(61, '[ [ -1680.7197265625, 421.130859375, 6.8796875, 0, 0, 496.1446533203125 ] ]', 0),
(62, '[ [ 1027.6162109375, -1122.05078125, 23.58025283813476, 0, 0, 367.0093841552734 ] ]', 0),
(63, '[ [ 696.9931640625, -500.1318359375, 16.0359375, 0, 0, 538.2723693847656 ] ]', 0),
(66, '[ [ 996.1337890625, -1296.017578125, 13.246875, 0, 0, 357.5994262695313 ] ]', 0),
(87, '[ [ 614.595703125, -124.068359375, 997.6921875, 1214, 3, 410.6422576904297 ] ]', 0),
(94, '[ [ 924.8447265625, -916.7177734375, 42.3015625, 0, 0, 366.2403411865234 ] ]', 0),
(102, '[ [ 1051.0595703125, -649.8291015625, 119.8105499267578, 0, 0, 273.6022033691406 ] ]', 0),
(107, '[ [ -2150.9404296875, -2462.30078125, 30.5515625, 0, 0, 324.4367065429688 ] ]', 0),
(108, '[ [ 253.5224609375, -1365.4814453125, 52.809375, 0, 0, 489.2396545410156 ] ]', 0),
(111, '[ [ 1309.5703125, -901.1669921875, 39.278125, 0, 0, 451.9844360351563 ] ]', 0),
(112, '[ [ 2527.7021484375, -1526.586303710938, 23.80691452026367, 0, 0, 537.7944641113281 ] ]', 0),
(114, '[ [ 1597.044921875, -1264.05078125, 17.15899200439453, 0, 0, 267.7628784179688 ] ]', 0),
(115, '[ [ 1465.166015625, -1760.85546875, 13.4734375, 0, 0, 360.9393463134766 ] ]', 0),
(117, '[ [ 1928.59375, -1769.4892578125, 13.0828125, 0, 0, 451.0066528320313 ] ]', 0);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `boltok`
--

CREATE TABLE `boltok` (
  `id` int(11) NOT NULL,
  `skin` int(3) NOT NULL,
  `pos` varchar(1000) NOT NULL,
  `type` int(1) NOT NULL DEFAULT 1,
  `name` varchar(50) NOT NULL DEFAULT 'Névtelen boltos'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- A tábla adatainak kiíratása `boltok`
--

INSERT INTO `boltok` (`id`, `skin`, `pos`, `type`, `name`) VALUES
(1, 242, '[ [ 1926.8408203125, -1766.84375, 13.48593711853027, 85.75234985351562, 0, 0 ] ]', 1, 'Ã‰lelmiszer'),
(2, 222, '[ [ 1926.841796875, -1767.7607421875, 13.48593711853027, 85.75234985351562, 0, 0 ] ]', 2, 'MÅ±szaki'),
(3, 294, '[ [ 1926.841796875, -1768.775390625, 13.48593711853027, 85.75234985351562, 0, 0 ] ]', 3, 'VegyesBolt'),
(5, 269, '[ [ -790.1533203125, -1897.201171875, 8.262294769287109, 50.10116577148438, 0, 0 ] ]', 5, 'Boltos'),
(6, 15, '[ [ -1181.91796875, -1131.2783203125, 129.21875, 1.244232177734375, 0, 0 ] ]', 5, 'Boltos'),
(7, 50, '[ [ 1457.888671875, -1813.0478515625, 13.7734375, 2.524139404296875, 0, 0 ] ]', 5, 'HobbiBoltos'),
(9, 108, '[ [ 1012.0625, -909.4638671875, 42.2109375, 100.1995544433594, 0, 0 ] ]', 1, 'Jason'),
(12, 120, '[ [ 1012.2373046875, -910.787109375, 42.2109375, 100.062255859375, 0, 0 ] ]', 3, 'Morgan'),
(13, 134, '[ [ 1442.455078125, -1812.9384765625, 13.7734375, 1.832000732421875, 0, 0 ] ]', 1, 'Ã‰lelmiszeres'),
(14, 108, '[ [ 1480.01171875, -1813.1171875, 20.984375, 1.963836669921875, 0, 0 ] ]', 3, 'VegyesÃrÃºs'),
(15, 224, '[ [ 1433.5830078125, -1813.0302734375, 20.984375, 355.761962890625, 0, 0 ] ]', 2, 'MÅ±szakiÃrÃºs'),
(16, 209, '[ [ 1469.7958984375, -1812.845703125, 13.7734375, 1.128875732421875, 0, 0 ] ]', 3, 'VegyesÃrÃºs'),
(17, 161, '[ [ 1461.0810546875, -1812.552734375, 20.984375, 1.128875732421875, 0, 0 ] ]', 5, 'HobbiBoltos'),
(19, 148, '[ [ 1165.240234375, -1322.06640625, 15.36250019073486, 182.2247619628906, 0, 0 ] ]', 4, 'GyÃ³gyszeres'),
(20, 270, '[ [ 2190.4228515625, 1604.5, 1005.069030761719, 64.02105712890625, 577, 1 ] ]', 1, 'Kaja'),
(21, 153, '[ [ 824.0244140625, 1.1103515625, 1004.1796875, 278.6257629394531, 595, 3 ] ]', 1, 'Wayne'),
(23, 226, '[ [ 244.1484375, 1041.6376953125, 1084.012573242188, 73.48040771484375, 593, 7 ] ]', 1, 'HÃ¼tÅ‘'),
(29, 118, '[ [ 379.7587890625, -71.4921875, 1001.5078125, 90.04254150390625, 652, 10 ] ]', 1, 'kaja'),
(34, 68, '[ [ -2027.095703125, -106.2666015625, 1035.171875, 90.223876953125, 543, 3 ] ]', 1, 'Petike'),
(36, 235, '[ [ 332.8212890625, 1118.6474609375, 1083.890258789063, 358.2668762207031, 669, 5 ] ]', 1, 'Eric'),
(39, 178, '[ [ -2157.994140625, 637.224609375, 1057.586059570313, 89.93817138671875, 825, 1 ] ]', 4, 'Parker'),
(40, 182, '[ [ 1214.3583984375, -15.2607421875, 1000.921875, 5.984893798828125, 872, 2 ] ]', 1, 'Deril'),
(41, 26, '[ [ 2144.4228515625, -1366.580078125, 25.64178276062012, 183.5156707763672, 0, 0 ] ]', 1, 'EladÃ³'),
(49, 99, '[ [ 1167.92578125, -1322.0673828125, 15.35604476928711, 180.3076171875, 0, 0 ] ]', 1, 'Ã‰lelmiszer'),
(51, 229, '[ [ -2237.373046875, 128.5849609375, 1035.4140625, 0.24444580078125, 1016, 6 ] ]', 5, 'Malcolm'),
(52, 104, '[ [ -72.09355163574219, -1180.232421875, 2.185937404632568, 334.3547668457031, 0, 0 ] ]', 1, 'Bunny'),
(53, 180, '[ [ -1683.5185546875, 421.3359375, 7.285937309265137, 133.2579650878906, 0, 0 ] ]', 1, 'Chester'),
(54, 104, '[ [ -1600.109375, -2705.3681640625, 48.5859375, 53.82559204101563, 0, 0 ] ]', 1, 'Colby'),
(57, 88, '[ [ -2655.5068359375, 1410.3427734375, 906.2734375, 265.9418640136719, 1173, 3 ] ]', 3, 'V_Max'),
(58, 1, '[ [ -2662.8408203125, 1410.24609375, 906.2734375, 88.59234619140625, 1173, 3 ] ]', 3, 'V_Max'),
(59, 21, '[ [ 380.7099609375, -189.1142578125, 1000.6328125, 182.9608612060547, 1334, 17 ] ]', 1, 'Jack'),
(60, 285, '[ [ 380.6591796875, -187.619140625, 1000.6328125, 87.08172607421875, 1334, 17 ] ]', 2, 'Salvatore'),
(64, 279, '[ [ -223.3076171875, 1402.91796875, 27.7734375, 83.736328125, 1294, 18 ] ]', 1, 'Steven'),
(65, 247, '[ [ 970.8369140625, -45.337890625, 1001.1171875, 95.28863525390625, 1167, 3 ] ]', 1, 'ASD'),
(67, 293, '[ [ 380.697265625, -189, 1000.6328125, 154.2696533203125, 1651, 17 ] ]', 1, 'Valaki'),
(68, 275, '[ [ 295.3291015625, 1489.947265625, 1080.2578125, 187.0368499755859, 1618, 15 ] ]', 5, 'Ganjaman'),
(69, 221, '[ [ 1214.3837890625, -15.26171875, 1000.921875, 3.58984375, 1635, 2 ] ]', 1, 'Linda'),
(70, 281, '[ [ 1215.9423828125, -15.2607421875, 1000.921875, 3.9029541015625, 1635, 2 ] ]', 3, 'Linda'),
(75, 232, '[ [ -2125.23828125, -173.12890625, 35.3203125, 32.07232666015625, 0, 0 ] ]', 2, 'Teszt'),
(76, 73, '[ [ 1591.986328125, -1276.44140625, 17.48190879821777, 179.14306640625, 0, 0 ] ]', 1, 'Pablo'),
(78, 91, '[ [ 501.8525390625, -21.2412109375, 1000.6796875, 89.87777709960938, 1838, 17 ] ]', 1, 'Marvin'),
(79, 304, '[ [ -786.912109375, 498.3212890625, 1371.7421875, 357.9208068847656, 1742, 1 ] ]', 1, 'William'),
(80, 260, '[ [ 497.7275390625, -77.4619140625, 998.7650756835938, 2.925140380859375, 1462, 11 ] ]', 1, 'Beer'),
(81, 271, '[ [ 681.4970703125, -455.4619140625, -25.6098747253418, 357.9427795410156, 1887, 1 ] ]', 1, 'a');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `changelog`
--

CREATE TABLE `changelog` (
  `id` int(11) NOT NULL,
  `script` varchar(1000) NOT NULL,
  `leiras` varchar(1000) NOT NULL,
  `developer` varchar(100) NOT NULL,
  `datum` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- A tábla adatainak kiíratása `changelog`
--

INSERT INTO `changelog` (`id`, `script`, `leiras`, `developer`, `datum`) VALUES
(1, 'fv_changelog', 'Changelog kÃ©szen van', 'Csoki', '2019-02-17'),
(2, 'fv_factioncommands', '/jail parancs a rendÅ‘rÃ¶knek', 'Csoki', '2019-02-23'),
(3, 'fv_inventory', 'Item hasznÃ¡lat flood vÃ©delem.', 'Csoki', '2019-02-23'),
(4, 'fv_gate', 'Kapuk gyorsabban nyÃ­lnak/csukÃ³dnak.', 'Csoki', '2019-02-23'),
(5, 'fv_radar', 'Blip mÃ©ret Ã¡llÃ­tÃ¡sa, kisebb fixek', 'Csoki', '2019-02-26'),
(6, 'fv_mdc', 'KÃ©sz', 'Csoki', '2019-02-26'),
(7, 'fv_chat', '/d fix', 'Csoki', '2019-02-26'),
(8, 'fv_admin', 'Adminduty logolÃ¡s hozzÃ¡adva.', 'Csoki', '2019-02-26'),
(9, 'fv_mdc', 'Chat szÃ¶vegek hozzÃ¡adva.', 'Csoki', '2019-02-27'),
(10, 'fv_mdc', 'BTK hozzÃ¡adva', 'Csoki', '2019-03-03'),
(11, 'fv_factioncommands', '/heal javÃ­tva.', 'Csoki', '2019-03-03'),
(12, 'fv_dead', '/agyogyit mostmÃ¡r adminnevet Ã­r', 'Csoki', '2019-03-03'),
(13, 'fv_inventory', 'mozgatÃ¡s fixelve', 'Csoki', '2019-03-03'),
(14, 'fv_phone', 'kÃ©szen van az alap', 'Csoki', '2019-03-03'),
(15, 'fv_identity', 'AdÃ¡svÃ©teli vÃ¡sÃ¡rlÃ¡s hozzÃ¡adva', 'Csoki', '2019-03-03'),
(16, 'fv_inventoey', 'AdÃ¡svÃ©teli item kÃ©p (Ãœresnek is)', 'Csoki', '2019-03-03'),
(17, 'fv_nick', 'MostmÃ¡r nem tÅ±nik el az NPC neve.', 'Csoki', '2019-03-04'),
(18, 'fv_inventory', 'Fegyvert mostmÃ¡r nem lehet gÃ¶rgÅ‘vel elrakni', 'Csoki', '2019-03-04'),
(19, 'fv_inventory', 'Nagy fegyverekkel mostmÃ¡r lehet futni', 'Csoki', '2019-03-04'),
(20, 'fv_admin', '/recon parancs fixelve', 'Csoki', '2019-03-04'),
(21, 'fv_admin', 'AdminsegÃ©d chat fixelve', 'Csoki', '2019-03-04'),
(22, 'fv_interior', 'eladÃ¡st mÃ¡r csak annak Ã­rja ki aki bement a markerbe', 'Csoki', '2019-03-04'),
(23, 'fv_score', 'ID szerinti rendezÃ©s', 'Csoki', '2019-03-04'),
(24, 'fv_admin', '/sethelperlevel parancs', 'Csoki', '2019-03-04'),
(26, 'fv_vehicle', 'BekÃ¶tÃ¶tt Ã¶vvel mostmÃ¡r nem tudsz kiszÃ¡lni a jÃ¡rmÅ±bÅ‘l.', 'Csoki', '2019-03-05'),
(27, 'fv_interior', 'MostmÃ¡r csak a markerban Ã¡llva lehet bemenni az interiorba', 'Csoki', '2019-03-05'),
(28, 'fv_interior', 'MostmÃ¡r csak a markerban Ã¡llva lehet hasznÃ¡lni a liftet', 'Csoki', '2019-03-05'),
(29, 'fv_admin', '/recon mostmÃ¡r nem teleportÃ¡l a jÃ¡tÃ©kos utÃ¡n', 'Csoki', '2019-03-05'),
(30, 'fv_dead', 'Killog fix', 'Csoki', '2019-03-05'),
(31, 'fv_sell', 'Elveszi mostmÃ¡r az Ã¼res adÃ¡svÃ©telit', 'Csoki', '2019-03-05'),
(32, 'fv_hud', 'Ha vÃ¡ltozik a pÃ©nz akkor a hudon mutatja a vÃ¡ltozÃ¡s mÃ©rtÃ©kÃ©t', 'Csoki', '2019-03-05'),
(33, 'fv_shoprob', 'kÃ©sz', 'Csoki', '2019-03-05'),
(34, 'fv_phone', 'MostmÃ¡r van olyan hogy foglalt :D', 'Csoki', '2019-03-05'),
(35, 'fv_vehicle', 'bicikli fix', 'Csoki', '2019-03-05'),
(36, 'fv_dash', 'RangemelÃ©s fixelve', 'Csoki', '2019-03-05'),
(37, 'fv_skinshop', 'A skinshop NPC-t nem lehet mostmÃ¡r megÃ¶lni', 'Csoki', '2019-03-05'),
(38, 'fv_interior', 'Interior betÃ¶ltÃ©s lagfix', 'Csoki', '2019-03-05'),
(39, 'fv_chat', 'Emoji rp fix', 'Csoki', '2019-03-05'),
(40, 'fv_realtime', 'IdÅ‘jÃ¡rÃ¡s API csere.', 'Csoki', '2019-03-05'),
(41, 'fv_score', 'ÃšjraÃ­rÃ¡s', 'Csoki', '2019-03-06'),
(42, 'fv_dash', 'GÃ¶rgetÃ©sek fixelve.', 'Csoki', '2019-03-06'),
(43, 'fv_phone', 'rendvÃ©delem,szerelÅ‘,taxi,mentÅ‘ hÃ­vÃ¡sa.', 'Csoki', '2019-03-07'),
(44, 'fv_admin', '/togpm, /toga parancsok', 'Csoki', '2019-03-08'),
(45, 'fv_inventory', 'CsomagtartÃ³ fix', 'Csoki', '2019-03-08'),
(46, 'fv_ppshop', 'pÃ©nz vÃ¡sÃ¡rlÃ¡s', 'Csoki', '2019-03-08'),
(47, 'fv_inventory', 'SzÃ©f javÃ­tva', 'Csoki', '2019-03-08'),
(48, 'fv_siren', 'Fordba is van szirÃ©na.', 'Csoki', '2019-03-08'),
(49, 'fv_vehicle', 'ZÃ¡rt biciklirÅ‘l lelehet szÃ¡llni', 'Csoki', '2019-03-08'),
(50, 'fv_hud', 'Kocsiban nem megy a stamina', 'Csoki', '2019-03-08'),
(51, 'fv_chat', 'Taxinak /gov', 'Csoki', '2019-03-08'),
(52, 'fv_interface', 'LoginpanelnÃ©l nincs HUD szerkesztÃ©s', 'Csoki', '2019-03-08'),
(53, 'fv_chat', 'SzerelÅ‘nek /gov', 'Csoki', '2019-03-08'),
(54, 'fv_charpanel', 'Animba nem lehet tolatni mostmÃ¡r', 'Csoki', '2019-03-08'),
(55, 'fv_admin', 'recon fix', 'Csoki', '2019-03-09'),
(56, 'fv_vehicle', 'MunkajÃ¡rmÅ±vet is lehet mostmÃ¡r getelni', 'Csoki', '2019-03-09'),
(57, 'fv_refill', 'SF-ben benzinkÃºt javÃ­tva', 'Csoki', '2019-03-09'),
(58, 'fv_shop', 'Telefon Ã¡r javÃ­tva', 'Csoki', '2019-03-09'),
(59, 'fv_bank', 'Kisebb fix', 'Csoki', '2019-03-09'),
(60, 'fv_inteiror', 'ZÃ¡rt garÃ¡zsba mostmÃ¡r nem lehet bemenni kocsival', 'Csoki', '2019-03-09'),
(61, 'fv_inventory', 'Kaja,Pia mostmÃ¡r eltÅ±nik az inventorybÃ³l', 'Csoki', '2019-03-09'),
(62, 'fv_dash', 'Tagok rendezÃ©se.', 'Csoki', '2019-03-09'),
(63, 'fv_phone', 'MostmÃ¡r nem tudod magadat felhÃ­vni', 'Csoki', '2019-03-09'),
(64, 'fv_hud', 'Lassaban szomjazol/Ã©hezel', 'Csoki', '2019-03-09'),
(65, 'fv_dead', 'Kisebb fix a killoghoz', 'Csoki', '2019-03-09'),
(66, 'fv_charpanel', 'Animba esÃ©s fix', 'Csoki', '2019-03-09'),
(67, 'fv_inventory', 'StackelÃ©s fix', 'Csoki', '2019-03-09'),
(68, 'fv_shop', 'Vegyesboltba csak 1 telefon van mostmÃ¡r', 'Csoki', '2019-03-09'),
(69, 'fv_vehdoor', 'zÃ¡rt kocsit mostmÃ¡r nem lehet kinyitni', 'Csoki', '2019-03-09'),
(70, 'fv_factioncommands', '/heal-t mostmÃ¡r csak mentÅ‘s hasznÃ¡lhatja', 'Csoki', '2019-03-10'),
(71, 'fv_refill', 'TankolÃ¡s fix', 'Csoki', '2019-03-10'),
(72, 'fv_index', 'kisebb fix', 'Csoki', '2019-03-10'),
(73, 'fv_chat', '/d Ã©s /m eltÃ¡volÃ­tva SzerelÅ‘nÃ©l Ã©s TaxinÃ¡l', 'Csoki', '2019-03-10'),
(74, 'fv_phone', 'Random chatkiirÃ¡s kiszedve :D', 'Csoki', '2019-03-10'),
(75, 'fv_inventory', 'Kisebb fix', 'Csoki', '2019-03-10'),
(76, 'fv_phone', 'Fraki hÃ­vÃ¡s javÃ­tva, Ã©s a tagoknak kiirja hogyha valaki fogadta.', 'Csoki', '2019-03-10'),
(77, 'fv_sell', 'MostmÃ¡r kell Ã¼res adÃ¡svÃ©teli az eladÃ¡shoz.', 'Csoki', '2019-03-10'),
(78, 'fv_refill', 'DimenziÃ³ fix.', 'Csoki', '2019-03-11'),
(79, 'fv_jobs', 'DokkmunkÃ¡s fix', 'Csoki', '2019-03-11'),
(80, 'fv_chat', 'SÃ¼rgÅ‘ssÃ©gi rÃ¡diÃ³t mostmÃ¡r taxi Ã©s szerelÅ‘ nem lÃ¡tja.', 'Csoki', '2019-03-11'),
(83, 'fv_carshop', 'Ãšj kocsik kerÃ¼ltek be', 'Nevils', '2019-03-12'),
(85, 'fv_handlings', 'Ãšj handling, Jobban vezethetÅ‘ kocsik,gyorsulÃ¡s,vÃ©gsebessÃ©g', 'Nevils', '2019-03-12'),
(87, 'fv_junk', 'ZÃºzda bekerÃ¼lt.', 'Csoki', '2019-03-12'),
(88, 'fv_mechanic', 'Fix', 'Csoki', '2019-03-12'),
(89, 'fv_weaponship', 'FegyverhajÃ³ a bandÃ¡soknak, maffiÃ¡knak. DokkoknÃ¡l', 'Csoki', '2019-03-12'),
(90, 'fv_interior', 'Lift fix', 'Csoki', '2019-03-12'),
(91, 'fv_quit', 'Ha valaki kilÃ©p a kÃ¶zeledben akkor ki Ã­rja a chatbe!', 'Nevils', '2019-03-13'),
(92, 'fv_handlings', 'Ha veszel egy Ãºj kocsit arra is kerÃ¼l mÃ¡r handling!', 'Nevils', '2019-03-13'),
(93, 'fv_taffipax', 'Ha Ã¡t megy egy kÃ¶rÃ¶zÃ¶tt kocsi jelzi!', 'Nevils', '2019-03-15'),
(94, 'fv_dash', 'f3 most mÃ¡r mutassa mennyi tag van fent', 'Nevils', '2019-03-15'),
(95, 'fv_vehmods', 'Ki lett vÃ©ve a vontatÃ³ modell', 'Nevils', '2019-03-16'),
(96, 'fv_vehicle', 'Most mÃ¡r kocsibÃ³l is lÃ¡tod a jÃ¡rmÅ± rendszÃ¡mÃ¡t (f10)', 'Nevils', '2019-03-16'),
(97, 'fv_inventory', 'FÃ©mdetektor van!', 'Nevils', '2019-03-16'),
(98, 'fv_charpanel', 'Most mÃ¡r ha felsegÃ­tesz valakit nem freezelÅ‘dsz le', 'Nevils', '2019-03-16'),
(99, 'fv_phone', 'ElÃ­rÃ¡sok javÃ­tva.', 'Csoki', '2019-03-18'),
(100, 'fv_phone', 'RendvÃ©delem nem lÃ¡tja a darkwebet', 'Csoki', '2019-03-18'),
(101, 'fv_dash', 'JÃ¡rmÅ± jelÃ¶lÃ©s blip hozzÃ¡adva.', 'Csoki', '2019-03-18'),
(102, 'fv_shoprob', 'Egyszerre ketten nem tudjÃ¡k.', 'Csoki', '2019-03-18'),
(103, 'fv_dash', 'JÃ¡tÃ©kos alatti Ã¡rnyÃ©k kiszedve, tÃ¡mogatÃ¡s jelzÃ©s hozzÃ¡adva.', 'Csoki', '2019-03-18'),
(104, 'fv_charpanel', 'kisebb fix', 'Csoki', '2019-03-18'),
(105, 'fv_inventory', 'LÅ‘szer bug fixelve', 'Csoki', '2019-03-18'),
(106, 'fv_mdc', 'GÃ¶rgetÃ©s', 'Csoki', '2019-03-18'),
(107, 'fv_charpanel', 'Animba nem tudsz felszedni mÃ¡sik animba esett jÃ¡tÃ©kost', 'Csoki', '2019-03-19'),
(108, 'fv_siren', 'Fix + Fordnak is van szirÃ©nÃ¡ja', 'Csoki', '2019-03-19'),
(109, 'fv_mechanic', 'SzerelÃ©s javÃ­tva.', 'Csoki', '2019-03-19'),
(110, 'fv_inventory', 'Kisebb fix', 'Csoki', '2019-03-19'),
(111, 'fv_admin', 'ElÃ­rÃ¡s javÃ­tva', 'Csoki', '2019-03-20'),
(112, 'fv_dash', 'slot vÃ¡sÃ¡rlÃ¡s javÃ­tva', 'Csoki', '2019-03-20'),
(113, 'fv_mechanic', 'SzÃ©lvÃ©dÅ‘ javÃ­tÃ¡s hozzÃ¡adva', 'Csoki', '2019-03-20'),
(114, 'fv_factioncommands', 'IC-Jail Fix', 'Csoki', '2019-03-20'),
(115, 'fv_dash', 'ElÃ­rÃ¡s javÃ­tvaa', 'Csoki', '2019-03-20'),
(116, 'fv_phone', 'RendvÃ©delem nem lÃ¡tja a darkwebet', 'Csoki', '2019-03-20'),
(117, 'fv_mapfix', 'Kisebb mapfix', 'Csoki', '2019-03-20'),
(118, 'fv_mapfix', 'szerelÅ‘nÃ©l lebegÅ‘ ablak kiszedve', 'Csoki', '2019-03-20'),
(119, 'fv_admin', 'ElÃ­rÃ¡s javÃ­tva', 'Csoki', '2019-03-20'),
(120, 'fv_speedo', '/fp mostmÃ¡r meghalva nem megy', 'Csoki', '2019-03-20'),
(121, 'fv_vehicle', 'Ãšjra lett Ã­rva!', 'Csoki', '2019-03-21'),
(122, 'fv_hatar', 'Ãšjra lett Ã­rva', 'DomOffical', '2019-03-21'),
(123, 'fv_vehicle', 'kisebb fix', 'Nevils', '2019-03-21'),
(124, 'fv_vehicle', 'Bugok fixelve', 'Csoki', '2019-03-21'),
(125, 'fv_dead', 'Respawn utÃ¡n kaja,pia maxra tÃ¶lt.', 'Csoki', '2019-03-21'),
(126, 'fv_chat', '/co az ooc tÃ¶rlÃ©sre', 'Csoki', '2019-03-21'),
(127, 'fv_phone', 'Telefon nem lÃ¡tszik dashboardnÃ¡l.', 'Csoki', '2019-03-21'),
(128, 'fv_taxiclock', 'Taxi Ã¶sszeg emelve', 'Csoki', '2019-03-21'),
(129, 'fv_dash', 'SÃ©tastÃ­lus vÃ¡lasztÃ¡s.', 'Csoki', '2019-03-21'),
(130, 'fv_dash', 'MostmÃ¡r a jÃ¡rmÅ±vek rendes nevÃ©t Ã­rja', 'Csoki', '2019-03-21'),
(131, 'fv_speedo', '/fp fix', 'Csoki', '2019-03-21'),
(132, 'fv_vehicle', 'Ãœzemanyag fogyasztÃ¡s javÃ­tva.', 'Csoki', '2019-03-22'),
(133, 'fv_charpanel', 'AdminsegÃ©d mostmÃ¡r nem tud bilincselni bÃ¡rkit', 'Csoki', '2019-03-22'),
(134, 'fv_jobs', 'MunkÃ¡k fixelve, fizetÃ©sek emelve', 'Csoki', '2019-03-22'),
(135, 'fv_chat', 'Bind fix + placedo limit', 'Csoki', '2019-03-22'),
(136, 'fv_traffipax', 'RendvÃ©delmi tagoknak mutatja ha kÃ¶rÃ¶zÃ¶tt jÃ¡rmÅ±vet ha bÃ¼ntet a trafi.', 'Csoki', '2019-03-22'),
(137, 'fv_inventory', 'Fix,fuel,unflip,heal kÃ¡rtyÃ¡k', 'Csoki', '2019-03-22'),
(138, 'fv_ppshop', 'KÃ¡rtyÃ¡k hozzÃ¡adva.', 'Csoki', '2019-03-22'),
(139, 'fv_traffipax', 'MostmÃ¡r kevÃ©sbÃ© bÃ¼ntet a trafi', 'Csoki', '2019-03-22'),
(140, 'fv_dash', 'ÃttekintÃ©snÃ©l mostmÃ¡r lÃ¡tod a skined.', 'Csoki', '2019-03-23'),
(141, 'fv_account', 'Ãšj zene, Eltudod menteni az adatokat', 'Csoki', '2019-03-23'),
(142, 'fv_hatar', 'Kisebb fix.', 'Csoki', '2019-03-26'),
(143, 'fv_vehicle', 'Motor zÃ¡rÃ¡s javÃ­tva + km szÃ¡mlÃ¡lÃ¡s.', 'Csoki', '2019-03-26'),
(144, 'fv_speedo', 'megtett km kiÃ­rÃ¡sa.', 'Csoki', '2019-03-26'),
(145, 'fv_animpanel', '/headmove parancs hozzÃ¡adva.', 'Csoki', '2019-03-26'),
(146, 'fv_vehicle', 'Motoron, biciklin Ã¶v fix + zÃ¡rÃ¡s/nyitÃ¡s kisebb fix', 'Csoki', '2019-03-26'),
(147, 'fv_dash', 'Skin fix', 'Csoki', '2019-03-26'),
(148, 'fv_factioncommands', '/heal mostmÃ¡r frakciÃ³ szÃ¡mlÃ¡ra megy.', 'Csoki', '2019-03-26'),
(149, 'fv_charpanel', 'Anim cserÃ©lve.', 'Csoki', '2019-03-26'),
(150, 'fv_charpanel', 'MostmÃ¡r bilincsben is lehet motozni.', 'Csoki', '2019-03-26'),
(151, 'fv_factioncommands', 'MostmÃ¡r nem a sofÅ‘r mellÃ© rakja be akit visz a jÃ¡tÃ©kos.', 'Csoki', '2019-03-26'),
(152, 'fv_charpanel', 'bilincs kisebb fix', 'Csoki', '2019-03-26'),
(153, 'fv_inventory', 'Sok fix hosszÃº lenne leÃ­rni', 'Csoki', '2019-03-30'),
(154, 'fv_bone', 'Kisebb fix', 'Csoki', '2019-03-30'),
(155, 'fv_score', 'AdminsegÃ©det mostmÃ¡r szinesen Ã­rja + Admint is ha dutyban van.', 'Csoki', '2019-04-04'),
(156, 'fv_admin', 'ElÃ­rÃ¡s javÃ­tva', 'Csoki', '2019-04-04'),
(157, 'fv_dx', 'Kisebb fix', 'Csoki', '2019-04-04'),
(158, 'fv_phone', 'MostmÃ¡r az editboxban lÃ©vÅ‘ szÃ¶veg tÃ¶rlÅ‘dik kÃ¼ldÃ©s utÃ¡n', 'Csoki', '2019-04-04'),
(159, 'fv_quit', 'ElÃ­rÃ¡s fix', 'Csoki', '2019-04-04'),
(160, 'fv_tuning', 'Tuning bekerÃ¼lt.', 'Csoki', '2019-04-05'),
(161, 'fv_vehicle', '/cveh Ã©s F6 ajtÃ³ kezelÃ©s', 'Csoki', '2019-04-05'),
(162, 'fv_vehicle', 'rendszÃ¡mokat messzebbrÅ‘l mutatja', 'Csoki', '2019-04-05'),
(163, 'fv_dash', 'MostmÃ¡r Ã­rja a tuningokat is.', 'Csoki', '2019-04-06'),
(164, 'fv_tuning', 'Air-Ride fix', 'Csoki', '2019-04-06'),
(165, 'fv_vehmods', 'fix', 'Csoki', '2019-04-06'),
(166, 'fv_radio', 'Teljes ÃºjraÃ­rÃ¡s.', 'Csoki', '2019-04-07'),
(167, 'modellek', 'sf mapfix', 'Csoki', '2019-04-07'),
(168, 'fv_vehicle', 'kisebb fix', 'Csoki', '2019-04-09'),
(169, 'fv_radar', 'Fixek + GPS', 'Csoki', '2019-04-09'),
(170, 'fv_nick', '/shownames parancs hozzÃ¡adva.', 'Csoki', '2019-04-09'),
(171, 'fv_ticket', 'MostmÃ¡r akit bÃ¼ntetnek, Ã©s kilÃ©p akkor is levonja a pÃ©nzt', 'Csoki', '2019-04-09'),
(172, 'fv_ticket', 'MostmÃ¡r frakinak megy a pÃ©nz', 'Csoki', '2019-04-09'),
(173, 'fv_traffipax', 'MostmÃ¡r Ã¶vet is nÃ©zi a trafi + Piros lÃ¡mpa bÃ¼ntet', 'Csoki', '2019-04-09'),
(174, 'fv_tuning', 'KerÃ©k szÃ©lessÃ©g fix + Tuning betÃ¶ltÃ©s fix.', 'Csoki', '2019-04-12'),
(175, 'fv_vehicle', '/park mostmÃ¡r normÃ¡lisan mÅ±kÃ¶dik.', 'Csoki', '2019-04-12'),
(176, 'fv_vehicle', 'kisebb fix', 'Csoki', '2019-04-14'),
(177, 'fv_tuning', 'variÃ¡ns bugfix', 'Csoki', '2019-04-14'),
(178, 'fv_anim', '/fall,/fallfront mostmÃ¡r nem megy kocsiba + /walk eltÃ¡volÃ­tva.', 'Csoki', '2019-04-14'),
(179, 'fv_interior', 'GarÃ¡zs fix', 'Csoki', '2019-04-16'),
(180, 'fv_easter', 'HÃºsvÃ©ti event bekerÃ¼lt', 'Csoki', '2019-04-18'),
(181, 'fv_sell', 'mostmÃ¡r csak akkor tudsz jÃ¡rmÅ±vet venni ha van szabad slotod', 'Csoki', '2019-04-19'),
(182, 'fv_charpanel', 'Bilincs kisebb fix', 'Csoki', '2019-04-19'),
(183, 'fv_index', 'LÃ¡mpa bug javÃ­tva', 'Csoki', '2019-04-19'),
(184, 'fv_inventory', 'mostmÃ¡r zÃ¡rt kocsinak nem lehet megnyitni a csomagtartÃ³jÃ¡t', 'Csoki', '2019-04-19'),
(185, 'fv_dash', 'mostmÃ¡r a kurzort elÅ‘hozza/eltÃ¼nteti', 'Csoki', '2019-04-19'),
(186, 'fv_realtime', 'kisebb fix', 'Csoki', '2019-04-22'),
(187, 'fv_radio', 'Nem mÅ±kÃ¶dÅ‘ adÃ³k kiszedve', 'Csoki', '2019-04-22'),
(188, 'fv_anim', '/dive mostmÃ¡r nem megy kocsiba', 'Csoki', '2019-04-22'),
(189, 'fv_nick', 'MostmÃ¡r nem Ã­rja hogy [JÃ¡tÃ©kos]', 'Csoki', '2019-04-23'),
(190, 'fv_sell', '/pay kisebb fix', 'Csoki', '2019-04-23'),
(191, 'fv_tuning', 'Turbo hang', 'Csoki', '2019-04-23'),
(192, 'fv_dash', 'TÃ¡mogatÃ¡s fÃ¼l frissÃ­tve', 'Csoki', '2019-04-23'),
(193, 'fv_dash', 'FrakciÃ³ betÃ¶ltÃ©s fix', 'Csoki', '2019-04-23'),
(194, 'fv_phone', 'HÃ­rdetÃ©sek/DarkWeb ki-be kapcsolÃ¡sa', 'Csoki', '2019-04-23'),
(195, 'fv_mdc', 'KeresÃ©s EmbereknÃ©l-JÃ¡rmÅ±veknÃ©l.', 'Csoki', '2019-04-23'),
(196, 'fv_tuning', 'FordulÃ³kÃ¶r javÃ­tva', 'Csoki', '2019-04-23'),
(197, 'fv_hatar', 'Ãšj + MappolÃ¡s hozzÃ¡', 'Csoki', '2019-04-26'),
(198, 'fv_tuning', 'Turbo hang cserÃ©lve.', 'Csoki', '2019-04-26'),
(199, 'fv_radio', 'HangosÃ­tva.', 'Csoki', '2019-04-28'),
(200, 'fv_inventory', 'Fegyver a hÃ¡ton + Craft + Fixek', 'Csoki', '2019-04-30'),
(201, 'fv_anticheat', 'BekerÃ¼lt.', 'Csoki', '2019-05-01'),
(202, 'fv_dash', 'FizetÃ©s idÅ‘ mentÃ©se.', 'Csoki', '2019-05-01'),
(203, 'fv_jobs', 'Kisebb fix + FizetÃ©sek vÃ¡ltoztak', 'Csoki', '2019-05-01'),
(204, 'fv_inventory', 'Kisebb fixek', 'Csoki', '2019-05-01'),
(205, 'fv_inventory', 'StackelÃ©s fix', 'Csoki', '2019-05-01'),
(206, 'fv_wdestroy', 'MostmÃ¡r kidurran a gumi ha tÃºlmelegszik', 'Csoki', '2019-05-03'),
(207, 'fv_glue', '/glue parancs', 'Csoki', '2019-05-03'),
(208, 'fv_infobox', 'kisebb anim fix', 'Csoki', '2019-05-03'),
(209, 'fv_label', 'DÃ¡tum hozzÃ¡adva.', 'Csoki', '2019-05-03'),
(210, 'fv_inventory', 'Craft kisebb fix', 'Csoki', '2019-05-03'),
(211, 'fv_fishing', 'BekerÃ¼lt.', 'Csoki', '2019-05-03'),
(212, 'fv_identity', 'HorgÃ¡szengedÃ©ly bekerÃ¼lt.', 'Csoki', '2019-05-03'),
(213, 'fv_admin', 'recon fix', 'Csoki', '2019-05-03'),
(214, 'fv_inventory', 'KÃ¡rtyÃ¡k javÃ­tva.', 'Csoki', '2019-05-04'),
(215, 'fv_inventory', 'actionbar kisebb fix', 'Csoki', '2019-05-04'),
(216, 'fv_inventory', 'HorgÃ¡szbot fix', 'Csoki', '2019-05-05'),
(217, 'fv_inventory', 'CsomagtartÃ³ bug javÃ­tva.', 'Csoki', '2019-05-05'),
(218, 'fv_fishing', 'bugfix', 'Csoki', '2019-05-07'),
(219, 'fv_fishing', 'Horgaszasi tavolsag fix', 'Csoki', '2019-05-07'),
(220, 'fv_bank', 'AdÃ³ mostmÃ¡r az Ã¶nkormÃ¡nyzat szÃ¡mlÃ¡ra megy.', 'Csoki', '2019-05-10'),
(221, 'fv_phone', 'FrakciÃ³ hÃ­vÃ¡snÃ¡l kijelszi honnan hÃ­vtak.', 'Csoki', '2019-05-10'),
(222, 'fv_weaponskill', 'Fegyver SkillezÃ©s bekerÃ¼lt.', 'Csoki', '2019-05-10'),
(223, 'fv_inventory', 'FegyverkÃ¶nyvek bekerÃ¼ltek.', 'Csoki', '2019-05-10'),
(224, 'fv_ppshop', 'MesterkÃ¶nyvek bekerÃ¼ltek.', 'Csoki', '2019-05-10'),
(225, 'fv_inventory', 'Item hasznÃ¡lat kisebb fix.', 'Csoki', '2019-05-11'),
(226, 'fv_identity', 'AutÃ³siskola javÃ­tva.', 'Csoki', '2019-05-11'),
(227, 'fv_weaponlicense', 'FegyverengedÃ©ly kivÃ¡ltÃ¡s bekerÃ¼lt.', 'Csoki', '2019-05-14'),
(228, 'kresz-rendszer', 'DÃ©lin Ãºt kÃ¶zepÃ©n lÃ©vÅ‘ tÃ¡bla kiszedve (Reconnect)', 'Csoki', '2019-05-14'),
(229, 'fv_hud', 'fegyver melegedÃ©s + fegyver widget.', 'Csoki', '2019-05-14'),
(230, 'fv_sell', 'Slot bug javÃ­tva', 'Csoki', '2019-05-14'),
(231, 'fv_dash', 'cÃ©lkereszt vÃ¡lasztÃ¡s', 'Csoki', '2019-05-15'),
(232, 'fv_inventory', 'Motozott jÃ¡tÃ©kosnak mostmÃ¡r nem lehet hasznÃ¡lni a tÃ¡rgyait', 'Csoki', '2019-05-15'),
(233, 'fv_inventory', 'CsomagtartÃ³ kisebb fix', 'Csoki', '2019-05-15'),
(234, 'fv_inventory', 'Stack fix', 'Csoki', '2019-05-18'),
(235, 'fv_weaponlicense', 'Fegyver vÃ¡sÃ¡rlÃ¡s bekerÃ¼lt.', 'Csoki', '2019-05-18'),
(236, 'fv_inventory', 'Item hasznÃ¡lat fix', 'Csoki', '2019-05-18'),
(237, 'fv_refill', 'BenzÃ­nkÃºt modell lerakva!', 'Nevils', '2019-05-19'),
(238, 'fv_shoprob', 'Most mÃ¡r tÃ¶bb benzÃ­nkuton lehet rabolni!', 'Nevils', '2019-05-19'),
(240, 'fv_inventory', 'kisebb fix', 'Csoki', '2019-05-19'),
(241, 'fv_account', 'zene cserÃ©lve.', 'Csoki', '2019-05-20'),
(242, 'fv_hud', 'kisebb fix', 'Csoki', '2019-05-20'),
(243, 'fv_account', 'betÃ¶ltÃ©snÃ©l nem lÃ¡tszik a HUD', 'Csoki', '2019-05-20'),
(244, 'fv_inventory', 'Craft kisebb bugfix', 'Csoki', '2019-05-20'),
(245, 'fv_handlings', 'Ãšj handlings', 'Nevils', '2019-05-20'),
(246, 'fv_radar', 'Ãšj iconok', 'Nevils', '2019-05-21'),
(247, 'fv_carshop', '3DB Ãºj kocsi', 'Nevils', '2019-05-21'),
(248, 'fv_inventory', 'Ãšj design + sok fix', 'Csoki', '2019-05-21'),
(249, 'fv_carshop', '4DB kocsi jÃ¶tt be!', 'Nevils', '2019-05-24'),
(250, 'fv_skins', 'FrakciÃ³ fejlesztÃ©sek elbirÃ¡lva', 'Nevils', '2019-05-24'),
(251, 'fv_dash', 'GÃ¶rgetÃ©s kisebb fix', 'Csoki', '2019-05-25'),
(252, 'fv_hud', 'LÅ‘szer jelzÃ©s hozzÃ¡adva.', 'Csoki', '2019-05-26'),
(253, 'fv_inventory', 'actionbar fix', 'Csoki', '2019-05-26'),
(254, 'fv_infobox', 'Tipusoknak kÃ¼lÃ¶n hangok.', 'Csoki', '2019-05-27'),
(255, 'fv_inventory', 'hÃ¡ton lÃ©vÅ‘ fegyver fix', 'Csoki', '2019-05-27'),
(256, 'fv_szerencsekerek', 'bekerÃ¼lt', 'ibacs', '2019-05-30'),
(257, 'fv_szerencsekerek', 'Kisebb fix', 'Csoki', '2019-05-30'),
(258, 'fv_szerencsekerek', 'Bugg javÃ­tva', 'Nevils', '2019-05-30'),
(259, 'fv_hud', 'Coin widget', 'Csoki', '2019-05-31'),
(260, 'fv_plant', 'Drog rendszer bekerÃ¼lt.', 'Csoki', '2019-06-03'),
(261, 'fv_inventory', 'FÃ¼ves cigi craft hozzÃ¡adva + fixek', 'Csoki', '2019-06-03'),
(262, 'fv_inventory', 'LoginnÃ¡l mÃ¡r nem lehet megnyitni', 'Csoki', '2019-06-03'),
(263, 'fv_dx', 'Editbox tÃ­pusok fixelve, mostmÃ¡r van csak szÃ¡mos is.', 'Csoki', '2019-06-03'),
(264, 'fv_interior', 'Most mÃ¡r bemehetsz kÃ¶rÃ¼lnÃ©zni mielÅ‘tt megveszed', 'ibacs', '2019-06-03'),
(265, 'fv_szerencsekerek', 'Most mÃ¡r nagyobb coinokkal is lehet jÃ¡tszani', 'ibacs', '2019-06-05'),
(266, 'fv_radio', 'Lagg fixelve', 'Csoki', '2019-06-06'),
(267, 'fv_shop', 'NPC nevek random.', 'Csoki', '2019-06-06'),
(268, 'fv_hud', 'Fegyver skillezÃ©s kÃ¶zben nem melegedik a fegyver', 'Csoki', '2019-06-06'),
(269, 'fv_dash', 'Adminok oldal fix', 'Csoki', '2019-06-07'),
(270, 'fv_phone', 'Most mÃ¡r van nÃ©vjegyzÃ©k illetve a hÃ¡ttÃ©rkÃ©pet is lehet Ã¡llÃ­tani', 'ibacs', '2019-06-09'),
(271, 'fv_plant', 'NÃ¶vekedÃ©s fix', 'Csoki', '2019-06-12'),
(272, 'fv_inventory', 'FixelÃ©sek + jogsi mostmÃ¡r hasznÃ¡lhatÃ³', 'Csoki', '2019-06-13'),
(273, 'fv_inventory', 'kisebb fix + /resetinvpos az inventory alap helyzetbe Ã¡llÃ­tÃ¡sÃ¡hoz', 'Csoki', '2019-06-17'),
(274, 'fv_dash', 'BeÃ¡llÃ­tÃ¡sok kisebb fix + frakciÃ³ betÃ¶ltÃ©s optimalizÃ¡lva.', 'Csoki', '2019-06-17'),
(275, 'fv_hud', 'skillezÃ©snÃ©l nem melegszik fel a fegyvered', 'Csoki', '2019-06-17'),
(276, 'fv_plant', 'NÃ¶vekedÃ©s bug javÃ­tva.', 'Csoki', '2019-06-21'),
(277, 'fv_mechanic', 'Automatikus SzerelÅ‘ marker, ha nincs szerelÅ‘', 'ibacs', '2019-06-23'),
(278, 'fv_interface', 'MÃ©retezÃ©s bekerÃ¼lt.', 'Csoki', '2019-06-24'),
(279, 'fv_radar', 'mÃ©retezÃ©s hozzÃ¡adva.', 'Csoki', '2019-06-24'),
(280, 'fv_mechanic', 'Kisebb fix.', 'ibacs', '2019-06-24'),
(281, 'fv_dash', 'FizetÃ©s fix + banki kezelÃ©si kÃ¶ltsÃ©g', 'Csoki', '2019-06-25'),
(282, 'fv_szerencsekerek', 'Kisebb fix.', 'ibacs', '2019-06-26'),
(283, 'fv_szerencsekerek', 'Ha pÃ¶rgetsz mÃ¡r nem tÅ±nik el a panel.', 'ibacs', '2019-06-26'),
(284, 'fv_bank', 'JÃ¡rmÅ±ben Ã¼lve mostmÃ¡r nem lehet hasznÃ¡lni az NPC/ATM-et', 'Csoki', '2019-06-27'),
(285, 'fv_dash', 'FrakciÃ³ szÃ¡mla kezelÃ©st mostmÃ¡r jÃ¡rmÅ±bÅ‘l nem lehet', 'Csoki', '2019-06-27'),
(286, 'fv_fishing', 'HorgÃ¡szbot bug javÃ­tva', 'Csoki', '2019-06-27'),
(287, 'fv_inventory', 'Drog craftok bekerÃ¼ltek', 'Csoki', '2019-06-27'),
(288, 'fv_shop', 'craft itemek bekerÃ¼lt a hobbiboltba', 'Csoki', '2019-06-27'),
(289, 'fv_vehicle', 'F10 StÃ¡tusz mentÃ©s', 'Csoki', '2019-07-08'),
(290, 'fv_vehicle', 'JÃ¡rmÅ±vek mentÃ©se javÃ­tva', 'Csoki', '2019-07-08'),
(291, 'fv_vehicle', '/dl parancs', 'Csoki', '2019-07-08'),
(292, 'fv_vehicle', 'J helyett J + SPACE a beindÃ­tÃ¡shoz.', 'Csoki', '2019-07-08'),
(293, 'fv_vehicle', 'Ãœzemanyag bug javÃ­tva.', 'Csoki', '2019-07-08'),
(294, 'fv_vehicle', 'Ã–v bug javÃ­tva + Ã¶v hang cserÃ©lve.', 'Csoki', '2019-07-08'),
(295, 'fv_refill', 'Ãœzemanyag Ã¡r a tÃ¶bbi Ã¡rhoz igazÃ­tva.', 'Csoki', '2019-07-08'),
(296, 'fv_dash', 'JÃ¡rmÅ±veknÃ©l motorszÃ¡m Ã©s alvÃ¡zszÃ¡m kiszedve, mert nem volt lÃ©nyege.', 'Csoki', '2019-07-08'),
(297, 'fv_vehicle', '/park fix', 'Csoki', '2019-07-09'),
(298, 'fv_tuning', 'Paintjob Ã¡r nem kerÃ¼l mÃ¡r drÃ¡gÃ¡ba.', 'Nevils', '2019-07-12'),
(299, 'fv_szerencsekerek', 'Ãšj design + Fixek + mostmÃ¡r tÃ¶bb tÃ©t lehet egyszerre', 'Csoki', '2019-07-12'),
(300, 'fv_refill', 'Benzin Ã¡r lentebb vÃ©ve.', 'Csoki', '2019-07-12'),
(301, 'fv_hud', 'Ã¡tkerÃ¼lt az interfacebe', 'Csoki', '2019-07-12'),
(302, 'fv_interface', 'Ãšj hud + pÃ¡r widget', 'Csoki', '2019-07-12'),
(303, 'fv_score', 'MostmÃ¡r nem annyira Ã¡tlÃ¡tszÃ³ a hÃ¡ttÃ©r.', 'Csoki', '2019-07-12'),
(304, 'fv_interface', 'RÃ©gi hud szomjÃºsÃ¡g fix', 'Csoki', '2019-07-15'),
(305, 'fv_sell', 'PÃ©nz Ã¡tadÃ¡s mostmÃ¡r nem bugol el ha elfut a jÃ¡tÃ©kos', 'Worthless', '2019-08-19'),
(306, 'Map', 'bekerÃ¼lt az Ãºjabb mapolÃ¡s javÃ­tÃ¡sa', 'Worthless', '2019-08-19'),
(308, 'fv_mods_weapon', 'bekerÃ¼ltek a fegyvermodok', 'RICEFF', '2019-10-29'),
(309, 'fv_inventory', 'mostmÃ¡r Ãºjra tudod tÃ¶lteni a fegyvert, lett animÃ¡ciÃ³.', 'RICEFF', '2019-10-29'),
(311, 'fv_chat', 'Olyan szÃ­nen Ã­rja az admin nevÃ©t OOC-ben, amilyen szÃ­nÅ± az admin', 'RICEFF', '2019-10-29'),
(312, 'fv_charpanel', 'nem tudsz beÃ¼lni passengerbe javÃ­tva', 'RICEFF', '2019-10-29'),
(313, 'fv_carshop', 'kettÅ‘ Ãºj jÃ¡rmÅ± hozzÃ¡adva a carshophoz.', 'RICEFF', '2019-10-29');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `characters`
--

CREATE TABLE `characters` (
  `id` int(11) NOT NULL,
  `ownerAccountName` varchar(255) NOT NULL,
  `charname` varchar(255) NOT NULL,
  `position` varchar(255) NOT NULL DEFAULT '[ [ 1612.95105, -2311.93530, 13.5526, 0,0 ] ] ' COMMENT 'x, y, z, dim, int',
  `health` int(11) NOT NULL DEFAULT 100,
  `armor` int(11) NOT NULL DEFAULT 100,
  `skinid` int(3) NOT NULL,
  `gender` int(2) NOT NULL DEFAULT 1,
  `age` int(2) NOT NULL,
  `weight` int(3) NOT NULL,
  `height` int(3) NOT NULL,
  `fightStyle` int(3) NOT NULL DEFAULT 5,
  `walkStyle` int(3) NOT NULL DEFAULT 118,
  `money` bigint(255) NOT NULL DEFAULT 500,
  `bankmoney` bigint(255) NOT NULL DEFAULT 1000,
  `death` varchar(255) NOT NULL DEFAULT '0',
  `playedtime` int(255) NOT NULL DEFAULT 0,
  `premiumPoints` int(255) NOT NULL DEFAULT 0,
  `adminlevel` int(2) NOT NULL DEFAULT 0,
  `job` int(2) NOT NULL DEFAULT 0,
  `rot` int(4) NOT NULL,
  `adminduty` varchar(255) NOT NULL DEFAULT 'false',
  `food` int(3) NOT NULL DEFAULT 100,
  `drink` int(3) NOT NULL DEFAULT 100,
  `adminname` varchar(255) NOT NULL DEFAULT 'Ismeretlen',
  `level` varchar(255) NOT NULL DEFAULT '1',
  `deathReasons` varchar(256) NOT NULL DEFAULT '[ [ "Ismeretlen", "Ismeretlen" ] ]',
  `bone` varchar(256) NOT NULL DEFAULT '[ [ true, true, true, true, true ] ]',
  `adutytime` int(11) DEFAULT 0,
  `rtc` int(11) DEFAULT 0,
  `fix` int(11) DEFAULT 0,
  `fuel` int(11) DEFAULT 0,
  `ban` int(11) DEFAULT 0,
  `jail` int(11) DEFAULT 0,
  `kick` int(11) DEFAULT 0,
  `pm` int(11) NOT NULL DEFAULT 0,
  `valasz` int(11) NOT NULL DEFAULT 0,
  `vehSlot` int(11) NOT NULL DEFAULT 2,
  `intSlot` int(11) NOT NULL DEFAULT 2,
  `radiofreki` int(11) NOT NULL DEFAULT 0,
  `adminjail` varchar(1000) NOT NULL DEFAULT '[ false ]',
  `icjail` varchar(1000) NOT NULL DEFAULT '[ false ]',
  `weaponSkill` varchar(255) NOT NULL DEFAULT ' [ [ 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]',
  `payTime` int(4) NOT NULL DEFAULT 3600,
  `coins` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- A tábla adatainak kiíratása `characters`
--

INSERT INTO `characters` (`id`, `ownerAccountName`, `charname`, `position`, `health`, `armor`, `skinid`, `gender`, `age`, `weight`, `height`, `fightStyle`, `walkStyle`, `money`, `bankmoney`, `death`, `playedtime`, `premiumPoints`, `adminlevel`, `job`, `rot`, `adminduty`, `food`, `drink`, `adminname`, `level`, `deathReasons`, `bone`, `adutytime`, `rtc`, `fix`, `fuel`, `ban`, `jail`, `kick`, `pm`, `valasz`, `vehSlot`, `intSlot`, `radiofreki`, `adminjail`, `icjail`, `weaponSkill`, `payTime`, `coins`) VALUES
(8, 'Zorty', 'Zorty R Wilson', '[ [ 2133.9375, -1909.021484375, 13.546875, 0, 0, \"Willowfield\" ] ]', 100, 100, 15, 1, 21, 60, 190, 0, 118, 999673119, 999999999, 'false', 26, 999960999, 13, 0, 1, 'false', 98, 94, 'Zorty', '1', '[ [ \"Ismeretlen\", \"Ismeretlen\" ] ]', '[ [ true, true, true, true, true ] ]', 23, 0, 0, 0, 0, 0, 0, 0, 0, 8, 2, 0, '[ false ]', '[ false ]', ' [ [ 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', 2120, 320);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `factions`
--

CREATE TABLE `factions` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `type` int(2) NOT NULL,
  `vallet` int(11) NOT NULL DEFAULT 10000,
  `ranks` varchar(1000) NOT NULL,
  `lmessage` varchar(200) NOT NULL DEFAULT 'Nincs megadva.'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- A tábla adatainak kiíratása `factions`
--

INSERT INTO `factions` (`id`, `name`, `type`, `vallet`, `ranks`, `lmessage`) VALUES
(10, 'Tunisian Mafia', 2, 0, '[ [ [ \"OOC Rang\", 1 ], [ \"Associates\", 1 ], [ \"Soldiers\", 1 ], [ \"Caporegime\", 1 ], [ \"Underboss\", 1 ], [ \"Consigliere\", 1 ], [ \"Boss\", 1 ], [ \"\", 1 ], [ \"\", 1 ], [ \"\", 1 ], [ \"\", 1 ], [ \"\", 1 ], [ \"\", 1 ], [ \"\", 1 ], [ \"\", 1 ] ] ]', 'Leader: Daniel Makarov, Sergey Zakharov\nCo-Leader:Boris Othoknik\n'),
(52, 'San Andreas State Government', 4, 9264471, '[ [ [ \"OOC\\/PrÃ³baidÅ‘s\", 1 ], [ \"Secretary\", \"4000\" ], [ \"Uniformed Division - Officer\", \"5500\" ], [ \"Uniformed Division- Sergeant\", \"6500\" ], [ \"Uniformed Division - Captain\", \"7000\" ], [ \"Mayor\", \"8000\" ], [ \"Uniformed Division- Investigator\", \"8000\" ], [ \"Chief of Uniformed Division\", \"8000\" ], [ \"State Senator\", \"10000\" ], [ \"Party Leader\", \"10000\" ], [ \"Minister of Finance\", \"15000\" ], [ \"Minister of Interior\", \"15000\" ], [ \"Secretary of Defense\", \"15000\" ], [ \"Vice President\", \"25000\" ], [ \"President\", \"30000\" ] ] ]', 'RÃ¡diÃ³ frekvencia: 1816\n'),
(53, 'Los Santos Police Department', 3, 56529205, '[ [ [ \"Academy Student\", \"1000\" ], [ \"Police Officer I.\", \"5000\" ], [ \"Police Officer II.\", \"10000\" ], [ \"Police Officer III.\", \"15000\" ], [ \"Detective I.\", \"18000\" ], [ \"Detective II.\", \"20000\" ], [ \"Detective III.\", \"1300\" ], [ \"Sergeant I.\", \"18000\" ], [ \"Sergeant II.\", \"20000\" ], [ \"Lieutenant\", \"23000\" ], [ \"Captain\", \"25000\" ], [ \"Commander\", \"30000\" ], [ \"Assistant Chief of Police\", \"30000\" ], [ \"Chief of Police\", \"30000\" ], [ \"Admin.\", \"0\" ] ] ]', 'RÃ¡diÃ³ frekvencia: 9110\n'),
(54, 'Bureau of Alcohol, Tobacco and Firearms', 3, 62511553, '[ [ [ \"Common Officer\", \"500\" ], [ \"Special Agent\", \"500\" ], [ \"Security Agent\", \"600\" ], [ \"Trainer\", \"700\" ], [ \"Executive Assistant\", \"800\" ], [ \"HQ Overseer\", \"20000\" ], [ \"Agent Administrator\", \"1000\" ], [ \"Head Secretary\", \"1100\" ], [ \"Executive Manager\", \"30000\" ], [ \"Director\", \"1300\" ], [ \"Rang_11\", 1 ], [ \"Rang_12\", 1 ], [ \"AFK\", \"0\" ], [ \"Ãllat\", 1 ], [ \"Vittorio\", \"30000\" ] ] ]', '1298 - RÃ¡diÃ³frekvencia. \n'),
(55, 'Los Santos Medical Department', 5, 9248000, '[ [ [ \"Prob. Employee\", \"12000\" ], [ \"Resident\", \"14000\" ], [ \"Doctor\", \"16000\" ], [ \"EMT\", \"18000\" ], [ \"Paramedic \", \"19000\" ], [ \"Senior Paramedic\", \"20000\" ], [ \"Lead Paramedic\", \"22000\" ], [ \"Firefighter I\", \"2200\" ], [ \"Firefighter II\", \"2400\" ], [ \"Engineer\", \"2600\" ], [ \"Lieutenant\", \"3000\" ], [ \"Captain\", \"3500\" ], [ \"Leader of EMS\", \"25000\" ], [ \"Deputy Commissioner\", \"30000\" ], [ \"Commissioner\", \"30000\" ] ] ]', 'frekvencia 10700\nRÃ¡diÃ³fÃ³niÃ¡k frissÃ­tve! FÃ³rumon megtalÃ¡lhatÃ³ak.\n'),
(56, 'Los Santos Car Mechanic', 5, 5547858, '[ [ [ \"Mechanic Student\", \"800\" ], [ \"Mechanic I\", \"1500\" ], [ \"Mechanic II\", \"1900\" ], [ \"Mechanic III\", \"2100\" ], [ \"Advanced Mechanic\", \"2500\" ], [ \"Trucker\", \"3000\" ], [ \"Instructor\", \"4000\" ], [ \"Maintance Staff\", \"3400\" ], [ \"Site Manager\", \"6000\" ], [ \"Deputy Director\", \"9000\" ], [ \"Owner\", \"15000\" ], [ \"SzabadsÃ¡gon\\/Admin\", 1 ], [ \"Tiszteletbeli Tag\", \"10\" ], [ \"Trucker ll\", \"3800\" ], [ \"Rang_15\", 1 ] ] ]', 'rÃ¡diÃ³fÃ³nia :2203455\n\nGarÃ¡zsba lehet parkolni a civil kocsikkal a bejÃ¡rattal szembe lÃ©vÅ‘ falnÃ¡\nCASCO JELSZÃ“: RUS l\n'),
(57, 'Soprano Crime Family', 2, 727500, '[ [ [ \"Associate\", 1 ], [ \"Soldier\", 1 ], [ \"Sicario\", 1 ], [ \"Caporegime\", 1 ], [ \"Consigliere\", 1 ], [ \"Streetboss\", 1 ], [ \"Underboss\", 1 ], [ \"Don\", 1 ], [ \"Rang_9\", 1 ], [ \"Rang_10\", 1 ], [ \"Rang_11\", 1 ], [ \"Rang_12\", 1 ], [ \"Rang_13\", 1 ], [ \"Rang_14\", 1 ], [ \"Rang_15\", 1 ] ] ]', 'Angyalnak szÃ¡rnya van, Ã¶rdÃ¶gnek hatalma !\n'),
(58, 'E/S Murda Mafia Piru', 1, 0, '[ [ [ \"O.G\", 1 ], [ \"O.Y.G\", 1 ], [ \"Y.G\", 1 ], [ \"First Lady\", 1 ], [ \"\", 1 ], [ \"\", 1 ], [ \"\", 1 ], [ \"\", 1 ], [ \"\", 1 ], [ \"\", 1 ], [ \"\", 1 ], [ \"\", 1 ], [ \"\", 1 ], [ \"\", 1 ], [ \"\", 1 ] ] ]', 'ALL MONEY GANG\n'),
(59, 'Bahamas Harpys 13', 1, 10000, '[ [ [ \"Rang_1\", 1 ], [ \"Rang_2\", 1 ], [ \"Rang_3\", 1 ], [ \"Rang_4\", 1 ], [ \"Rang_5\", 1 ], [ \"Rang_6\", 1 ], [ \"Rang_7\", 1 ], [ \"Rang_8\", 1 ], [ \"Rang_9\", 1 ], [ \"Rang_10\", 1 ], [ \"Rang_11\", 1 ], [ \"Rang_12\", 1 ], [ \"Rang_13\", 1 ], [ \"Rang_14\", 1 ], [ \"Rang_15\", 1 ] ] ]', 'Nincs megadva.'),
(60, 'Wah Ching', 1, 10000, '[ [ [ \"T.G\", 1 ], [ \"B.G\", 1 ], [ \"O.B.G\", 1 ], [ \"Rang_4\", 1 ], [ \"Rang_5\", 1 ], [ \"Rang_6\", 1 ], [ \"Rang_7\", 1 ], [ \"Rang_8\", 1 ], [ \"Rang_9\", 1 ], [ \"Rang_10\", 1 ], [ \"Rang_11\", 1 ], [ \"Rang_12\", 1 ], [ \"Rang_13\", 1 ], [ \"Rang_14\", 1 ], [ \"Rang_15\", 1 ] ] ]', 'Skin ID-k. 153-157\n'),
(62, 'Cuban Crime Network', 2, 10000, '[ [ [ \"OOC\", 1 ], [ \"Outsider\", 1 ], [ \"Member\", 1 ], [ \"Street Boss\", 1 ], [ \"Boss\", 1 ], [ \"Rang_6\", 1 ], [ \"Rang_7\", 1 ], [ \"Rang_8\", 1 ], [ \"Rang_9\", 1 ], [ \"Rang_10\", 1 ], [ \"Rang_11\", 1 ], [ \"Rang_12\", 1 ], [ \"Rang_13\", 1 ], [ \"Rang_14\", 1 ], [ \"Rang_15\", 1 ] ] ]', '\n'),
(63, 'Los Santos News', 5, 4996000, '[ [ [ \"Leaner\", \"2000\" ], [ \"Driver\", \"2500\" ], [ \"Anchorman\", \"3000\" ], [ \"Reporter\", \"3500\" ], [ \"Newspaper Editor\", \"3500\" ], [ \"Editor in Chief\", \"4000\" ], [ \"Deputy Director\", \"5000\" ], [ \"Director\", \"6000\" ], [ \"Rang_9\", 1 ], [ \"Rang_10\", 1 ], [ \"Rang_11\", 1 ], [ \"Rang_12\", 1 ], [ \"Rang_13\", 1 ], [ \"Rang_14\", 1 ], [ \"Rang_15\", 1 ] ] ]', 'RÃ¡diÃ³ :2552252\n'),
(65, 'Serb Mafia', 2, 158500, '[ [ [ \"\", 1 ], [ \"\", 1 ], [ \"\", 1 ], [ \"\", 1 ], [ \"\", 1 ], [ \"SoffÅ‘r\", 1 ], [ \"BiztonsÃ¡giÅ‘r\", 1 ], [ \"FelszolgÃ¡lÃ³\", 1 ], [ \" ÑƒÐ¿ÑƒÑ›ÐµÐ½Ð¸(upucÌeni)\", 1 ], [ \" Ñ‚ÐµÐ»Ð¾Ñ…Ñ€Ð°Ð½Ð¸Ñ‚ÐµÑ™(telohranitelj)\", 1 ], [ \"Ð´Ð¸Ð»ÐµÑ€ Ð´Ñ€Ð¾Ð³Ðµ(diler droge)\", 1 ], [ \" ÐŸÑ€Ð¾Ð´Ð°Ð²Ð°Ñ‡ Ð¾Ñ€ÑƒÐ¶Ñ˜Ð°(ProdavaÄ oruÅ¾ja)\", 1 ], [ \"ÑˆÑ‚Ð°Ð¼Ð¿Ð°( Å¡tampa)\", 1 ], [ \"Ð´ÐµÑÐ½Ð° Ñ€ÑƒÐºÐ° (desna ruka)\", 1 ], [ \"Ð²Ð»Ð°ÑÐ½Ð¸Ðº(vlasnik)\", 1 ] ] ]', 'Fraki:20011104\n\n'),
(68, 'Los Santos Taxicab Corporation', 5, 854000, '[ [ [ \"OOC | Admin  | SzabadsÃ¡g\", \"0\" ], [ \"Mechanical Engineer\", \"1000\" ], [ \"Dispatch \", \"1500\" ], [ \"Recruit Driver\", \"2500\" ], [ \"Taxicab Driver | Regular\", \"3000\" ], [ \"Taxicab Driver| Middle Class\", \"4000\" ], [ \"Taxicab Driver | High Class\", \"5000\" ], [ \"Limousine Driver\", \"6000\" ], [ \"Towtruck Driver\", \"7000\" ], [ \"Driver of the Month\", \"8000\" ], [ \"Taxi & Limousine Comissioner\", \"9000\" ], [ \"Assistant Manager of the Taxi Depot\", \"10000\" ], [ \"Manager of the Taxi Depot\", \"11000\" ], [ \"Deputy Director\", \"12000\" ], [ \"Owner of Los Santos Taxicab Corp.\", \"15000\" ] ] ]', 'URH rÃ¡diÃ³t alkalmazzuk! RÃ¡diÃ³ frekvencia: 1751122\n__________________________\nIngyenesen szÃ¡llÃ­tjuk a :\n-\n-\n-\n-\n\n'),
(69, 'Hell\'s Angels', 1, 0, '[ [ [ \"OOC \\/ Admin\", 1 ], [ \"Chaplain\", 1 ], [ \"Member\", 1 ], [ \"Prospect\", 1 ], [ \"Secretary\", 1 ], [ \"Road Captain\", 1 ], [ \"Sgt. at Arms\", 1 ], [ \"Vice - President\", 1 ], [ \"President\", 1 ], [ \"Rang_10\", 1 ], [ \"Rang_11\", 1 ], [ \"Rang_12\", 1 ], [ \"Rang_13\", 1 ], [ \"Rang_14\", 1 ], [ \"Rang_15\", 1 ] ] ]', 'Frekvencia : 99911\n\nA Frekvencia kiadÃ¡sa azonnali CK-t von maga utÃ¡n!\n');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `hengedelyek`
--

CREATE TABLE `hengedelyek` (
  `id` int(255) NOT NULL,
  `name` varchar(50) NOT NULL,
  `gender` int(1) NOT NULL DEFAULT 1,
  `date` date NOT NULL,
  `exdate` date NOT NULL,
  `cardid` varchar(6) NOT NULL DEFAULT '000000'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- A tábla adatainak kiíratása `hengedelyek`
--

INSERT INTO `hengedelyek` (`id`, `name`, `gender`, `date`, `exdate`, `cardid`) VALUES
(10, 'Zorty R Wilson', 1, '2020-03-30', '2020-04-30', 'HPRVSM');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `interiors`
--

CREATE TABLE `interiors` (
  `id` int(10) NOT NULL,
  `x` float DEFAULT NULL,
  `y` float DEFAULT NULL,
  `z` float DEFAULT NULL,
  `type` tinyint(4) DEFAULT NULL,
  `owner` int(11) NOT NULL DEFAULT 0,
  `locked` tinyint(4) NOT NULL DEFAULT 0,
  `cost` int(15) DEFAULT 0,
  `name` varchar(255) DEFAULT NULL,
  `faction` int(11) NOT NULL DEFAULT 0,
  `interior` int(11) DEFAULT NULL,
  `interiorx` float DEFAULT NULL,
  `interiory` float DEFAULT NULL,
  `interiorz` float DEFAULT NULL,
  `dimension` int(11) DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- A tábla adatainak kiíratása `interiors`
--

INSERT INTO `interiors` (`id`, `x`, `y`, `z`, `type`, `owner`, `locked`, `cost`, `name`, `faction`, `interior`, `interiorx`, `interiory`, `interiorz`, `dimension`) VALUES
(1536, 1093.7, -805.397, 107.419, 1, 2747, 0, 1, 'HÃ¡z', 0, 9, 2317.81, -1026.55, 1050.21, 0),
(1745, -789.406, 509.952, 1367.37, 3, 0, 0, 1, 'FolyosÃ³', 57, 1, 2266.32, 1647.59, 1084.23, 0),
(780, 1180.45, -1309.79, 13.6447, 4, 1928, 0, 0, 'LSMC', 6, 1, 1412.14, -2.28, 1000.92, 0),
(550, 280.895, -1767.8, 4.53869, 1, 977, 0, 100000, 'HÃ¡z', 0, 5, 140.39, 1366.36, 1083.85, 0),
(548, 295.399, -1764.84, 4.5474, 1, 377, 0, 80000, 'HÃ¡z', 0, 8, -42.65, 1405.46, 1084.42, 0),
(1743, 315.788, -1769.77, 4.63096, 1, 5091, 0, 1, 'HÃ¡z', 57, 9, 2317.81, -1026.55, 1050.21, 0),
(42, 168.221, -1769.69, 4.45885, 1, 2827, 0, 70000, 'HÃ¡z', 0, 7, 225.71, 1021.44, 1084.01, 0),
(52, -68.9482, -1546.23, 3.00431, 1, 88, 0, 10000, 'hÃ¡z', 0, 6, 2308.8, -1212.94, 1049.02, 0),
(1308, -90.1865, -1591.84, 2.99956, 1, 61, 0, 1, 'HÃ¡z', 0, 8, -42.65, 1405.46, 1084.42, 0),
(50, -88.9248, -1564.62, 3.00431, 1, 45, 0, 10000, 'HÃ¡z', 0, 10, 422.26, 2536.37, 10, 0),
(55, 142.966, -1469.81, 25.2036, 1, 1118, 0, 85000, 'LuxusHÃ¡z', 0, 10, 2270.41, -1210.46, 1047.56, 0),
(1289, 166.619, -1340.37, 69.7328, 4, 195, 0, 1, 'GarÃ¡zs', 0, 1, 1412.14, -2.28, 1000.92, 0),
(1698, 345.865, -1197.27, 76.5156, 4, 3950, 0, 120000, 'GarÃ¡zs', 0, 2, 613.655, -74.5078, 997.992, 0),
(1290, 172.143, -1340.44, 69.7828, 4, 195, 0, 1, 'GarÃ¡zs', 0, 1, 1412.14, -2.28, 1000.92, 0),
(1222, 636.252, -1123.06, 44.5427, 4, 880, 0, 1, 'GarÃ¡zs', 0, 1, 1412.14, -2.28, 1000.92, 0),
(1293, 190.581, -1308.07, 70.2695, 1, 195, 0, 1, 'Luxus-HÃ¡z', 0, 6, 234.2, 1063.85, 1084.21, 0),
(1217, 1581.49, -1415.4, 13.5756, 4, 1933, 0, 1, 'GarÃ¡zs', 0, 1, 1412.14, -2.28, 1000.92, 0),
(85, 354.969, -1280.54, 53.7036, 1, 3823, 0, 500000, 'HÃ¡z', 0, 5, 2233.53, -1115.26, 1050.88, 0),
(80, 345.059, -1298.04, 50.759, 1, 3651, 0, 200000, 'HÃ¡z', 0, 6, 234.2, 1063.85, 1084.21, 0),
(81, 397.872, -1271.19, 50.0198, 1, 1746, 0, 650000, 'LuxusHÃ¡z', 0, 4, -260.78, 1456.73, 1084.36, 0),
(969, 1143.08, 6.12305, 1000.68, 1, 0, 0, 0, 'HÃ¡lÃ³', 18, 9, 83, 1322.48, 1083.86, 0),
(84, 431.499, -1252.82, 51.5809, 1, 1659, 0, 500000, 'HÃ¡z', 0, 12, 2324.42, -1149.2, 1050.71, 0),
(86, 543.241, -1202.69, 44.5653, 4, 1394, 0, 100000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(88, 553.063, -1200.22, 44.8315, 1, 1341, 0, 450000, 'HÃ¡z', 0, 2, 2237.52, -1081.64, 1049.02, 0),
(1219, 248.485, -1356.07, 53.1094, 4, 1153, 0, 0, 'GarÃ¡zs', 0, 1, 1412.14, -2.28, 1000.92, 0),
(90, 618.787, -1100.76, 46.7795, 4, 1217, 0, 100000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(94, 612.147, -1085.94, 58.8267, 1, 3392, 0, 750000, 'LuxusHÃ¡z', 0, 9, 2317.81, -1026.55, 1050.21, 0),
(1387, 165.631, -1746.2, 4.71613, 4, 4237, 0, 400000, 'GarÃ¡zs', 0, 1, 1412.14, -2.28, 1000.92, 0),
(98, 647.397, -1058.69, 52.5799, 1, 2718, 0, 750000, 'LuxusHÃ¡z', 0, 8, 2365.14, -1135.35, 1050.87, 0),
(99, 672.276, -1019.64, 55.7596, 1, 4274, 0, 700000, 'HÃ¡z', 0, 8, 2365.14, -1135.35, 1050.87, 0),
(100, 724.806, -994.581, 52.6111, 4, 2099, 0, 100000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(374, 724.707, -999.38, 52.7344, 1, 2099, 0, 2000000, 'LuxusHÃ¡z', 0, 5, 140.39, 1366.36, 1083.85, 0),
(105, 558.043, -1161.13, 54.4297, 1, 0, 0, 800000, 'LuxusHÃ¡z', 0, 6, 2196.85, -1204.4, 1049, 0),
(108, 471.092, -1164.54, 67.1756, 1, 977, 0, 950000, 'LuxusHÃ¡z', 0, 12, 2324.42, -1149.2, 1050.71, 0),
(109, 405.575, -1153.37, 77.2166, 4, 86, 0, 100000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(111, 416.378, -1154.86, 76.6876, 1, 764, 0, 950000, 'LuxusHÃ¡z', 0, 10, 24, 1340.33, 1084.37, 0),
(1046, 2290.14, -1882.05, 14.2344, 1, 3392, 0, 0, 'WeedRoom', 0, 1, 2218.24, -1076.27, 1050.48, 0),
(1113, 300.383, -1154.59, 81.3913, 1, 1910, 0, 0, 'WesleyBirtok', 0, 7, 225.71, 1021.44, 1084.01, 0),
(1700, 352.451, -1197.9, 76.5156, 1, 3950, 0, 0, 'HÃ¡z', 0, 6, 234.2, 1063.85, 1084.21, 0),
(1281, 275.836, -1251.17, 73.9151, 4, 3658, 0, 1, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(1282, 279.424, -1255.66, 73.9207, 4, 3658, 0, 1, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(1283, 253.218, -1269.73, 74.3355, 1, 3658, 0, 1, 'LuxusVilla', 0, 7, 225.71, 1021.44, 1084.01, 0),
(690, 251.599, -1220.59, 76.0222, 1, 591, 0, 0, 'LuxusVilla', 0, 10, 24, 1340.33, 1084.37, 0),
(129, 564.769, -1067.2, 73.4544, 4, 2050, 0, 100000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(1080, 558.883, -1076.03, 72.922, 1, 2050, 0, 80000, 'HÃ¡z', 0, 6, 234.2, 1063.85, 1084.21, 0),
(133, 497.515, -1094.51, 82.3592, 1, 2, 0, 2000000, 'LuxusHÃ¡z', 0, 6, 2196.85, -1204.4, 1049, 0),
(132, 479.638, -1091.01, 82.3913, 4, 2623, 0, 100000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(898, 503.946, -11.5654, 1000.68, 3, 0, 0, 0, 'TESZT2', 0, 17, 493.34, -24.48, 1000.67, 0),
(899, 503.264, -11.7686, 1000.68, 3, 0, 0, 0, 'TESZT2', 0, 17, 493.34, -24.48, 1000.67, 0),
(900, 503.264, -11.7686, 1000.68, 3, 0, 0, 0, 'TESZT2', 0, 17, 493.34, -24.48, 1000.67, 0),
(901, 503.264, -11.7686, 1000.68, 3, 0, 0, 0, 'TESZT2', 0, 17, 493.34, -24.48, 1000.67, 0),
(146, 867.729, -717.693, 105.68, 1, 1635, 0, 1000000, 'LuxusHÃ¡z', 0, 2, 446.97, 1397.22, 1084.3, 0),
(1260, 911.301, -664.636, 116.948, 4, 597, 0, 0, 'GarÃ¡zs', 0, 1, 1412.14, -2.28, 1000.92, 0),
(1259, 897.68, -677.482, 116.89, 1, 597, 0, 0, 'HÃ¡z', 0, 7, 225.71, 1021.44, 1084.01, 0),
(150, 946.136, -710.791, 122.62, 1, 575, 0, 950000, 'LuxusHÃ¡z', 0, 2, 2237.52, -1081.64, 1049.02, 0),
(968, 1143.08, 6.12305, 1000.68, 1, 0, 0, 0, 'HÃ¡lÃ³', 0, 9, 83, 1322.48, 1083.86, 0),
(967, 1143.11, 6.1709, 1000.68, 1, 0, 0, 0, 'HÃ¡lÃ³', 0, 9, 83, 1322.48, 1083.86, 0),
(973, 980.294, -677.005, 121.976, 1, 79, 0, 0, 'Lakatos', 0, 12, 1133.25, -15.26, 1000.67, 0),
(1417, 2807.28, -1165.13, 1025.57, 1, 0, 0, 100, 'Sum1', 0, 6, 343.98, 305.14, 999.14, 0),
(1538, 854.583, -605.003, 18.4219, 1, 293, 0, 200000, 'HÃ¡z.', 0, 7, 225.71, 1021.44, 1084.01, 0),
(1891, 1331.85, -632.751, 109.135, 1, 3306, 0, 0, 'HÃ¡z', 0, 9, 2317.81, -1026.55, 1050.21, 0),
(1056, 1442.59, -629.234, 95.7186, 1, 14, 0, 100000, 'LuxusVilla', 0, 5, 140.39, 1366.36, 1083.85, 0),
(171, 2556.42, 13.8008, 27.0698, 4, 2261, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(1215, 1517.7, -688.856, 94.75, 4, 1886, 0, 1, 'GarÃ¡zs', 0, 18, 1292.28, 0.033525, 1001.02, 0),
(173, 2555.82, 9.53809, 27.0636, 4, 832, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(174, 2556.01, 2.16309, 26.4766, 4, 2079, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(1214, 1517.44, -694.429, 94.75, 4, 1886, 0, 1, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(176, 2521.39, -25.3018, 27.6039, 4, 195, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(178, 2505.3, 8.11914, 27.5162, 4, 1479, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(179, 2501.73, 8.27441, 27.5413, 4, 1479, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(181, 1516.35, -764.718, 79.9068, 4, 2480, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(182, 2496.35, 8.85449, 27.6337, 4, 1311, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(183, 2492.94, 8.46875, 27.571, 4, 1311, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(184, 2484.47, -28.4023, 28.4416, 1, 195, 0, 120000, 'HÃ¡z', 0, 9, 83, 1322.48, 1083.86, 0),
(186, 2476.22, -25.1406, 27.5761, 4, 195, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(190, 2415.48, -52.2793, 28.1535, 1, 1704, 0, 120000, 'HÃ¡z', 0, 8, 2365.14, -1135.35, 1050.87, 0),
(188, 2438.85, -54.9648, 28.1535, 1, 246, 0, 120000, 'HÃ¡z', 0, 9, 83, 1322.48, 1083.86, 0),
(189, 2444.17, -52.9385, 27.4838, 4, 246, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(192, 2392.31, -54.96, 28.1536, 1, 2747, 0, 120000, 'HÃ¡z', 0, 8, 2365.14, -1135.35, 1050.87, 0),
(193, 2367.38, -49.127, 28.1535, 1, 343, 0, 120000, 'HÃ¡z', 0, 8, 2365.14, -1135.35, 1050.87, 0),
(827, 2397.7, -51.6602, 27.4838, 4, 2747, 0, 0, 'GarÃ¡zs', 0, 18, 1292.28, 0.033525, 1001.02, 0),
(1398, 1527.57, -772.992, 80.5781, 1, 689, 0, 0, 'HÃ¡z.', 0, 8, 2365.14, -1135.35, 1050.87, 0),
(196, 2411.22, -5.59473, 27.6835, 1, 249, 0, 120000, 'HÃ¡z', 0, 8, 2365.14, -1135.35, 1050.87, 0),
(197, 2358.15, -64.79, 27.4688, 4, 1185, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(198, 2417.01, 17.792, 27.6835, 1, 932, 0, 120000, 'HÃ¡z', 0, 8, 2365.14, -1135.35, 1050.87, 0),
(200, 1533.2, -813.538, 72.1273, 4, 3161, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(201, 2327.74, -122.24, 27.4838, 4, 1934, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(203, 1535.04, -800.214, 72.8495, 1, 1690, 0, 750000, 'HÃ¡z', 0, 15, 295.05, 1472.36, 1080.25, 0),
(204, 2413.59, 61.7637, 28.4416, 1, 2655, 0, 120000, 'HÃ¡z', 0, 9, 83, 1322.48, 1083.86, 0),
(206, 2443.41, 61.7598, 28.4416, 1, 2532, 0, 120000, 'HÃ¡z', 0, 9, 83, 1322.48, 1083.86, 0),
(207, 2254.94, -133.386, 27.4688, 4, 559, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(208, 2188.08, -79.9902, 27.4688, 4, 589, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(209, 1537.94, -842.009, 64.511, 4, 794, 0, 100000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(210, 2199.67, -66.1748, 27.4838, 4, 1152, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(1239, 2373.99, 42.0234, 28.4416, 1, 4272, 0, 1, 'HÃ¡z', 0, 3, 235.44, 1186.83, 1080.25, 0),
(1596, 2279.59, 3.67188, 27.4688, 4, 97, 0, 250000, 'GarÃ¡zs', 0, 1, 1412.14, -2.28, 1000.92, 0),
(215, 2398.38, 111.761, 28.4416, 1, 48, 0, 120000, 'HÃ¡z', 0, 9, 83, 1322.48, 1083.86, 0),
(216, 2240.45, -4.44141, 27.4838, 4, 273, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(217, 2323.85, 116.178, 28.4416, 1, 1879, 0, 120000, 'HÃ¡z', 0, 9, 83, 1322.48, 1083.86, 0),
(219, 2323.85, 136.385, 28.4416, 1, 221, 0, 120000, 'HÃ¡z', 0, 9, 83, 1322.48, 1083.86, 0),
(220, 2364, 142.065, 28.4416, 1, 224, 0, 120000, 'HÃ¡z', 0, 9, 83, 1322.48, 1083.86, 0),
(221, 2363.99, 116.118, 28.4416, 1, 1289, 0, 120000, 'HÃ¡z', 0, 9, 83, 1322.48, 1083.86, 0),
(1232, 1539.71, -851.395, 64.3361, 1, 157, 0, 0, 'LuxushÃ¡z', 1, 9, 2317.81, -1026.55, 1050.21, 0),
(223, 2323.85, 191.106, 28.4416, 1, 2133, 0, 120000, 'HÃ¡z', 0, 9, 83, 1322.48, 1083.86, 0),
(833, 2207.5, 57.8066, 27.5149, 4, 246, 0, 0, 'GarÃ¡zs', 0, 1, 1412.14, -2.28, 1000.92, 0),
(834, -2721.2, 923.963, 67.5938, 1, 1686, 0, 0, 'Caponekrisz', 0, 8, 2365.14, -1135.35, 1050.87, 0),
(226, 2285.87, 161.771, 28.4416, 1, 128, 0, 120000, 'HÃ¡z', 0, 8, 2365.14, -1135.35, 1050.87, 0),
(227, 2258.01, 168.338, 28.1536, 1, 626, 0, 120000, 'HÃ¡z', 0, 8, 2365.14, -1135.35, 1050.87, 0),
(229, 2207.43, 110.545, 27.5239, 4, 2432, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(1317, 2236.38, 166.942, 28.1535, 1, 250, 0, 1, 'HÃ¡z', 0, 15, 295.05, 1472.36, 1080.25, 0),
(233, 2252.45, 165.348, 27.4838, 4, 626, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(234, 2203.85, 106.119, 28.4416, 1, 5148, 0, 120000, 'HÃ¡z', 0, 9, 83, 1322.48, 1083.86, 0),
(235, 2290.29, 158.138, 27.5161, 4, 0, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(236, 2203.85, 62.1895, 28.4416, 1, 3361, 0, 120000, 'HÃ¡z', 0, 9, 83, 1322.48, 1083.86, 0),
(237, 2293.93, 157.43, 27.4012, 4, 128, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(238, 1535.92, -885.06, 57.6575, 1, 1103, 0, 800000, 'HÃ¡z', 0, 4, 261.14, 1284.56, 1080.25, 0),
(239, 2245.48, -1.66309, 28.1536, 1, 273, 0, 120000, 'HÃ¡z', 0, 8, 2365.14, -1135.35, 1050.87, 0),
(240, 2326.95, 123.755, 27.6019, 4, 1920, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(241, 2270.5, -7.49902, 28.1535, 1, 97, 0, 120000, 'HÃ¡z', 0, 8, 2365.14, -1135.35, 1050.87, 0),
(242, 2326.97, 121.146, 27.5994, 4, 1879, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(243, 2293.76, -124.964, 28.1535, 1, 1969, 0, 120000, 'HÃ¡z', 0, 8, 2365.14, -1135.35, 1050.87, 0),
(244, 2360.77, 120.76, 27.5837, 4, 2747, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(246, 2360.54, 123.756, 27.5456, 4, 2747, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(1708, 2268.17, -2018.84, 13.5469, 4, 38, 0, 0, 'Pumpa', 0, 18, 1292.28, 0.033525, 1001.02, 0),
(247, 2272.39, -119.135, 28.1535, 1, 1910, 0, 120000, 'HÃ¡z', 0, 8, 2365.14, -1135.35, 1050.87, 0),
(248, 2245.52, -122.291, 28.1535, 1, 559, 0, 120000, 'HÃ¡z', 0, 8, 2365.14, -1135.35, 1050.87, 0),
(250, 2322.4, -124.963, 28.1536, 1, 1934, 0, 120000, 'HÃ¡z', 0, 8, 2365.14, -1135.35, 1050.87, 0),
(251, 2326.86, 157.873, 27.6183, 4, 2961, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(252, 1468.74, -905.784, 54.8359, 1, 1130, 0, 1000000, 'LuxusHÃ¡z', 0, 2, 446.97, 1397.22, 1084.3, 0),
(253, 2359.38, 169.929, 27.3588, 4, 3565, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(254, 2359.54, 173.229, 27.3842, 4, 3720, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(255, 2364, 166.107, 28.4416, 1, 1971, 0, 120000, 'HÃ¡z', 0, 8, 2365.14, -1135.35, 1050.87, 0),
(1694, 2558.14, -1212.35, 54.5312, 4, 3724, 0, 200000, 'GarÃ¡zs', 0, 1, 1412.14, -2.28, 1000.92, 0),
(257, 2359.83, 182.435, 27.4296, 4, 38, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(258, 2364, 187.219, 28.4416, 1, 38, 0, 120000, 'HÃ¡z', 0, 8, 2365.14, -1135.35, 1050.87, 0),
(1431, 2327.46, 198.825, 27.5193, 4, 2133, 0, 0, 'GarÃ¡zs', 0, 1, 1412.14, -2.28, 1000.92, 0),
(611, 2403.04, 105.453, 27.0818, 4, 48, 0, 0, 'GarÃ¡zs', 0, 2, 613.655, -74.5078, 997.992, 0),
(1237, 2378.96, 34.5723, 27.2787, 4, 4272, 0, 1, 'GarÃ¡zs', 0, 2, 613.655, -74.5078, 997.992, 0),
(264, 2253.25, 108.196, 27.5274, 4, 0, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(265, 2249.32, 111.77, 28.4416, 1, 1426, 0, 120000, 'HÃ¡z', 0, 9, 83, 1322.48, 1083.86, 0),
(266, 2261.2, 107.607, 27.432, 4, 1341, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(267, 2269.41, 111.768, 28.4416, 1, 1426, 0, 120000, 'HÃ¡z', 0, 9, 83, 1322.48, 1083.86, 0),
(268, 2265.33, 107.706, 27.448, 4, 1461, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(778, 2399.69, -1135.67, 30.1137, 4, 110, 0, 5000, 'Atigarage', 0, 2, 613.655, -74.5078, 997.992, 0),
(271, 1421.78, -885.568, 50.662, 1, 2586, 0, 700000, 'HÃ¡z', 0, 5, 22.98, 1403.6, 1084.42, 0),
(272, 2377.15, 25.9932, 27.5719, 4, 436, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(273, 2373.85, 22.0537, 28.4416, 1, 620, 0, 120000, 'HÃ¡z', 0, 8, 2365.14, -1135.35, 1050.87, 0),
(801, 2411.45, 11.3701, 26.4844, 4, 932, 0, 0, 'Garage', 0, 2, 613.655, -74.5078, 997.992, 0),
(1285, 2375.11, -8.66113, 28.4416, 1, 4050, 0, 1, 'HÃ¡z', 0, 8, 2365.14, -1135.35, 1050.87, 0),
(276, 2414.22, 1.92383, 26.4844, 4, 249, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(277, 1463.88, -904.386, 54.8359, 4, 1130, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(278, 2512.82, 69.0596, 27.0634, 4, 2928, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(279, 1431.08, -884.642, 50.6981, 4, 2530, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(281, 2488.33, 11.7607, 28.4416, 1, 1311, 0, 120000, 'HÃ¡z', 0, 9, 83, 1322.48, 1083.86, 0),
(285, 2528.76, 131.46, 26.4844, 4, 7, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(282, 2513.53, 74.1641, 27.0561, 4, 3169, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(283, 2509.46, 11.7598, 28.4416, 1, 1479, 0, 120000, 'HÃ¡z', 0, 9, 83, 1322.48, 1083.86, 0),
(284, 2553.69, 81.2461, 26.4837, 4, 176, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(286, 2536.2, 128.987, 27.6835, 1, 383, 0, 120000, 'HÃ¡z', 0, 9, 83, 1322.48, 1083.86, 0),
(287, 2518.39, 128.986, 27.6756, 1, 3571, 0, 120000, 'HÃ¡z', 0, 9, 83, 1322.48, 1083.86, 0),
(1587, 2503.53, 94.7646, 26.4844, 4, 968, 0, 200000, 'GarÃ¡zs', 0, 1, 1412.14, -2.28, 1000.92, 0),
(289, 2480.68, 126.995, 27.6756, 1, 9, 0, 120000, 'HÃ¡z', 0, 9, 83, 1322.48, 1083.86, 0),
(290, 2496.36, 132.536, 27.0529, 4, 9, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(291, 2492.12, 133.22, 27.0599, 4, 9, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(292, 2462.71, 134.776, 27.6756, 1, 1955, 0, 120000, 'HÃ¡z', 0, 9, 83, 1322.48, 1083.86, 0),
(294, 2469.72, 130.881, 26.4766, 4, 0, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(1722, 1298.59, -800.091, 84.1406, 1, 1153, 0, 10000000, 'HÃ¡z', 0, 5, 1260.84, -785.42, 1091.9, 0),
(1849, 2421.62, -1219.59, 25.5392, 1, 5095, 0, 0, 'PigPen', 65, 2, 1204.81, -13.6, 1000.92, 0),
(1793, 1940.15, -2116.07, 13.6953, 3, 0, 0, 0, 'Sex', 0, 3, -100.4, -24.96, 1000.71, 0),
(298, 2484.85, 71.8213, 26.4844, 4, 4085, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(302, 2444.27, 11.583, 26.4844, 4, 149, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(1789, 2068.72, -1779.91, 13.5596, 3, 0, 0, 0, 'Tatto', 0, 3, -204.31, -44.08, 1002.27, 0),
(307, -2567.14, 1149.4, 55.7266, 4, 3032, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(308, -2556.08, 1146.55, 55.7266, 4, 554, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(311, -2541.42, 1143.03, 55.7266, 4, 2990, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(310, -2545.59, 1144.25, 55.7266, 4, 2718, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(312, -2530.88, 1142.42, 55.7266, 4, 2542, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(313, -2527.11, 1141.56, 55.7266, 4, 0, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(314, -2513.58, 1140.7, 55.7266, 4, 3451, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(315, 1111.52, -742.208, 100.133, 1, 2851, 0, 900000, 'LuxusHÃ¡z', 0, 6, 234.2, 1063.85, 1084.21, 0),
(316, -2510.13, 1140.95, 55.7266, 4, 0, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(317, -2498.95, 1140.67, 55.7266, 4, 5017, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(318, -2489.77, 1140.64, 55.7266, 4, 0, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(319, -2486.06, 1140.29, 55.7266, 4, 574, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(320, -2475.03, 1141.19, 55.7333, 4, 0, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(321, -2471.46, 1141.22, 55.7333, 4, 0, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(322, -2458.78, 1140.73, 55.7266, 4, 0, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(323, -2454.84, 1140.31, 55.7266, 4, 0, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(325, -2444.57, 1140.47, 55.7266, 4, 19, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(326, -2434.83, 1138.88, 55.7266, 4, 0, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(328, -2572.93, 1155.03, 55.7349, 1, 4529, 0, 150000, 'HÃ¡z', 0, 15, 295.05, 1472.36, 1080.25, 0),
(329, -2563.18, 1149.14, 55.7266, 1, 4594, 0, 150000, 'HÃ¡z', 0, 15, 295.05, 1472.36, 1080.25, 0),
(330, -2548.94, 1145.7, 55.7266, 1, 2718, 0, 150000, 'HÃ¡z', 0, 15, 295.05, 1472.36, 1080.25, 0),
(331, -2534.57, 1143.78, 55.7266, 1, 59, 0, 150000, 'HÃ¡z', 0, 15, 295.05, 1472.36, 1080.25, 0),
(332, -2506.42, 1142.16, 55.7266, 1, 3451, 0, 150000, 'HÃ¡z', 0, 15, 295.05, 1472.36, 1080.25, 0),
(333, -2493.43, 1141.97, 55.7266, 1, 574, 0, 150000, 'HÃ¡z', 0, 15, 295.05, 1472.36, 1080.25, 0),
(334, -2479.02, 1141.99, 55.7266, 1, 1916, 0, 150000, 'HÃ¡z', 0, 15, 295.05, 1472.36, 1080.25, 0),
(335, -2451.29, 1141.77, 55.7333, 1, 15, 0, 150000, 'HÃ¡z', 0, 15, 295.05, 1472.36, 1080.25, 0),
(336, -2430.72, 1139.35, 55.7266, 4, 0, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(337, -2424.05, 1139.45, 55.7266, 1, 3605, 0, 150000, 'HÃ¡z', 0, 15, 295.05, 1472.36, 1080.25, 0),
(338, -2420.77, 1137.72, 55.7266, 4, 3605, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(339, -2416.72, 1136.48, 55.7266, 4, 5711, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(340, -2396.73, 1132.77, 55.7333, 1, 1063, 0, 150000, 'HÃ¡z', 0, 15, 295.05, 1472.36, 1080.25, 0),
(1693, 1003.97, -1300.39, 13.3828, 4, 195, 0, 200000, 'GarÃ¡zs', 0, 1, 1412.14, -2.28, 1000.92, 0),
(1288, -2400.19, 1132.52, 55.7333, 4, 1063, 0, 0, 'GarÃ¡zs', 0, 2, 613.655, -74.5078, 997.992, 0),
(343, -2383.82, 1128.15, 55.7266, 1, 3931, 0, 150000, 'HÃ¡z', 0, 15, 295.05, 1472.36, 1080.25, 0),
(344, -2389.88, 1129.75, 55.7266, 4, 0, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(345, -2369.44, 1122.34, 55.7333, 1, 2590, 0, 150000, 'HÃ¡z', 0, 15, 295.05, 1472.36, 1080.25, 0),
(347, -2380.75, 1125.69, 55.7266, 4, 3329, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(1768, 1024.01, -778.086, 103.038, 4, 3392, 0, 800000, 'GarÃ¡zs', 0, 1, 1412.14, -2.28, 1000.92, 0),
(1692, 849.593, -1519.97, 14.3481, 1, 3557, 0, 150000, 'HÃ¡z', 0, 9, 2317.81, -1026.55, 1050.21, 0),
(349, -2366.52, 1118.59, 55.7333, 4, 2590, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(350, -2362.66, 1117.59, 55.7266, 4, 2660, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(1675, 1016.93, -763.502, 112.563, 1, 3392, 0, 650000, 'Luxus_Villa', 0, 3, 235.44, 1186.83, 1080.25, 0),
(1426, 2326.88, -1681.96, 14.9297, 1, 3950, 0, 150000, 'HÃ¡z.', 0, 2, 446.97, 1397.22, 1084.3, 0),
(1207, 977.525, -771.251, 112.203, 1, 377, 0, 1, 'LuxusHÃ¡z', 0, 3, 235.44, 1186.83, 1080.25, 0),
(871, 1597.89, -1554.59, 13.5837, 4, 1632, 0, 0, 'GarÃ¡zs', 0, 2, 613.655, -74.5078, 997.992, 0),
(1234, 943.655, -841.344, 94.1819, 4, 3323, 0, 1, 'MonsterGarÃ¡zs', 0, 2, 613.655, -74.5078, 997.992, 0),
(1679, 2104.88, -1889.09, 13.5469, 4, 162, 0, 80000, 'GarÃ¡zs', 0, 2, 613.655, -74.5078, 997.992, 0),
(1673, 925.205, -852.913, 93.4565, 1, 706, 0, 1, 'HÃ¡z', 0, 5, 226.56, 1114.19, 1080.99, 0),
(1228, 832.252, -890.061, 68.7734, 4, 764, 0, 0, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(365, 841.542, -897.02, 68.7734, 4, 973, 0, 100000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(1557, -2125.81, -2503.39, 30.6172, 4, 2099, 0, 1, 'GarÃ¡zs', 0, 1, 1412.14, -2.28, 1000.92, 0),
(373, 827.701, -858.021, 70.3308, 1, 150, 0, 700000, 'HÃ¡z', 0, 9, 260.67, 1237.32, 1084.25, 0),
(1238, 2379.16, 38.0293, 27.2464, 4, 4271, 0, 1, 'GarÃ¡zs', 0, 2, 613.655, -74.5078, 997.992, 0),
(378, 1886.12, -1113.69, 26.2758, 1, 2137, 0, 100000, 'HÃ¡z', 0, 8, -42.65, 1405.46, 1084.42, 0),
(379, 1905.97, -1113.26, 26.6641, 1, 375, 0, 100000, 'HÃ¡z', 0, 9, 83, 1322.48, 1083.86, 0),
(380, 1910.5, -1114.61, 25.6719, 4, 375, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(381, 1921.83, -1115.2, 27.0883, 1, 2702, 0, 100000, 'HÃ¡z', 0, 8, 2365.14, -1135.35, 1050.87, 0),
(382, 1939.08, -1114.48, 27.4453, 1, 5207, 0, 150000, 'HÃ¡z', 0, 9, 83, 1322.48, 1083.86, 0),
(383, 1955.45, -1115.24, 27.8305, 1, 3056, 0, 100000, 'HÃ¡z', 0, 9, 260.67, 1237.32, 1084.25, 0),
(1520, 1990.97, -1118.2, 26.7737, 4, 810, 0, 0, 'GarÃ¡zs.', 0, 1, 1412.14, -2.28, 1000.92, 0),
(1519, 2000.03, -1114.06, 27.125, 1, 810, 0, 0, 'HÃ¡z.', 0, 2, 446.97, 1397.22, 1084.3, 0),
(386, 2022.83, -1120.26, 26.4141, 1, 257, 0, 100000, 'HÃ¡z', 0, 9, 83, 1322.48, 1083.86, 0),
(387, 2045.23, -1116.21, 26.3617, 1, 433, 0, 100000, 'HÃ¡z', 0, 8, -42.65, 1405.46, 1084.42, 0),
(388, 2093.81, -1123.05, 27.6899, 1, 190, 0, 100000, 'HÃ¡z', 0, 8, -42.65, 1405.46, 1084.42, 0),
(389, 2095.36, -1145.18, 26.5859, 1, 922, 0, 150000, 'HÃ¡z', 0, 9, 83, 1322.48, 1083.86, 0),
(390, 2092.24, -1166.3, 26.5859, 1, 1786, 0, 150000, 'HÃ¡z', 0, 9, 83, 1322.48, 1083.86, 0),
(392, 2091.64, -1184.96, 27.0571, 1, 1344, 0, 100000, 'HÃ¡z', 0, 8, -42.65, 1405.46, 1084.42, 0),
(393, 2090.71, -1234.89, 25.6887, 1, 38, 0, 100000, 'HÃ¡z', 0, 8, -42.65, 1405.46, 1084.42, 0),
(394, 2110.85, -1243.91, 25.8516, 1, 3658, 0, 100000, 'HÃ¡z', 0, 8, -42.65, 1405.46, 1084.42, 0),
(395, 2133.47, -1232.63, 24.4219, 1, 2901, 0, 100000, 'HÃ¡z', 0, 8, -42.65, 1405.46, 1084.42, 0),
(396, 2153.83, -1243.57, 25.3672, 1, 18, 0, 100000, 'HÃ¡z', 0, 8, -42.65, 1405.46, 1084.42, 0),
(397, 2191.85, -1238.83, 24.1574, 1, 622, 0, 100000, 'HÃ¡z', 0, 8, -42.65, 1405.46, 1084.42, 0),
(398, 2209.84, -1239.48, 24.1496, 1, 5637, 0, 100000, 'HÃ¡z', 0, 9, 260.67, 1237.32, 1084.25, 0),
(399, 2224.9, -1242.69, 25.3719, 4, 2655, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(400, 2229.62, -1241.61, 25.6562, 1, 2655, 0, 100000, 'HÃ¡z', 0, 9, 260.67, 1237.32, 1084.25, 0),
(401, 2249.92, -1238.84, 25.8984, 1, 719, 0, 100000, 'HÃ¡z', 0, 8, -42.65, 1405.46, 1084.42, 0),
(1496, 2250.47, -1281.15, 25.4766, 1, 1980, 0, 1, 'HÃ¡z', 0, 9, 83, 1322.48, 1083.86, 0),
(403, 2230.04, -1280.07, 25.6285, 1, 1869, 0, 100000, 'HÃ¡z', 0, 9, 260.67, 1237.32, 1084.25, 0),
(404, 2207.93, -1280.82, 25.1207, 1, 2048, 0, 100000, 'HÃ¡z', 0, 9, 260.67, 1237.32, 1084.25, 0),
(405, 2196.18, -1273.85, 24.5439, 4, 195, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(406, 2191.45, -1275.6, 25.1562, 1, 195, 0, 100000, 'HÃ¡z', 0, 9, 260.67, 1237.32, 1084.25, 0),
(407, 2159.66, -1267.52, 23.9758, 4, 2588, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(408, 2150.24, -1285.04, 24.5269, 1, 1707, 0, 100000, 'HÃ¡z', 0, 9, 260.67, 1237.32, 1084.25, 0),
(1017, 2132.21, -1280.05, 25.8906, 1, 3851, 0, 0, 'HÃ¡z', 0, 1, 223.22, 1287.17, 1082.14, 0),
(410, 2111.2, -1279.65, 25.6875, 1, 2063, 0, 100000, 'HÃ¡z', 0, 9, 260.67, 1237.32, 1084.25, 0),
(411, 2095.54, -1277.07, 25.4934, 4, 1134, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(412, 2091.08, -1278.42, 26.1797, 1, 558, 0, 100000, 'HÃ¡z', 0, 9, 260.67, 1237.32, 1084.25, 0),
(413, 2100.75, -1321.69, 25.9531, 1, 152, 0, 100000, 'HÃ¡z', 0, 8, -42.65, 1405.46, 1084.42, 0),
(415, 2148.66, -1320.08, 26.0738, 1, 3407, 0, 100000, 'HÃ¡z', 0, 9, 260.67, 1237.32, 1084.25, 0),
(416, 2129.6, -1361.69, 26.1363, 1, 46, 0, 100000, 'HÃ¡z', 0, 8, -42.65, 1405.46, 1084.42, 0),
(417, 2147.71, -1366.77, 25.6418, 1, 1605, 0, 100000, 'HÃ¡z', 0, 9, 260.67, 1237.32, 1084.25, 0),
(419, 2202.52, -1363.67, 26.191, 1, 2428, 0, 100000, 'HÃ¡z', 0, 9, 260.67, 1237.32, 1084.25, 0),
(420, 2230.17, -1397.24, 24.5738, 1, 2807, 0, 100000, 'HÃ¡z', 0, 8, -42.65, 1405.46, 1084.42, 0),
(421, 2243.64, -1397.24, 24.5738, 1, 3437, 0, 100000, 'HÃ¡z', 0, 8, -42.65, 1405.46, 1084.42, 0),
(422, 2256.5, -1397.24, 24.5738, 1, 2808, 0, 100000, 'HÃ¡z', 0, 8, -42.65, 1405.46, 1084.42, 0),
(423, 2196.28, -1404.12, 25.9488, 1, 2587, 0, 100000, 'HÃ¡z', 0, 9, 260.67, 1237.32, 1084.25, 0),
(424, 2188.56, -1419.4, 26.1562, 1, 4492, 0, 100000, 'HÃ¡z', 0, 9, 260.67, 1237.32, 1084.25, 0),
(425, 2194.53, -1443.14, 25.7433, 1, 997, 0, 100000, 'HÃ¡z', 0, 9, 260.67, 1237.32, 1084.25, 0),
(426, 2191.11, -1455.73, 26, 1, 1375, 0, 100000, 'HÃ¡z', 0, 8, -42.65, 1405.46, 1084.42, 0),
(1528, 2190.64, -1470.35, 25.9141, 1, 4563, 0, 1, 'hÃ¡z', 0, 6, 234.2, 1063.85, 1084.21, 0),
(428, 2190.32, -1487.71, 26.1051, 1, 3380, 0, 100000, 'HÃ¡z', 0, 9, 260.67, 1237.32, 1084.25, 0),
(430, 2191.21, -1504.53, 23.9439, 4, 1, 0, 700000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(431, 2183.69, -1503.83, 23.9524, 4, 2063, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(432, 2176.28, -1502.09, 23.9601, 4, 1284, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(433, 2232.48, -1469.34, 24.5816, 1, 1501, 0, 100000, 'HÃ¡z', 0, 8, -42.65, 1405.46, 1084.42, 0),
(434, 2247.65, -1469.34, 24.4801, 1, 3780, 0, 100000, 'HÃ¡z', 0, 8, -42.65, 1405.46, 1084.42, 0),
(435, 2263.74, -1469.34, 24.3707, 1, 3342, 0, 100000, 'HÃ¡z', 0, 8, -42.65, 1405.46, 1084.42, 0),
(436, 2151.19, -1400.66, 26.1285, 1, 1958, 0, 100000, 'HÃ¡z', 0, 9, 260.67, 1237.32, 1084.25, 0),
(437, 2150.8, -1418.87, 25.9219, 1, 1134, 0, 100000, 'HÃ¡z', 0, 8, -42.65, 1405.46, 1084.42, 0),
(438, 2149.85, -1433.5, 26.0703, 1, 595, 0, 100000, 'HÃ¡z', 0, 8, -42.65, 1405.46, 1084.42, 0),
(439, 2152.22, -1446.38, 26.1051, 1, 1107, 0, 100000, 'HÃ¡z', 0, 9, 260.67, 1237.32, 1084.25, 0),
(440, 2146.8, -1470.68, 26.0426, 1, 1119, 0, 100000, 'HÃ¡z', 0, 9, 260.67, 1237.32, 1084.25, 0),
(441, 2148.93, -1484.94, 26.624, 1, 1114, 0, 200000, 'HÃ¡z', 0, 9, 83, 1322.48, 1083.86, 0),
(442, 2383.53, -1366.38, 24.4914, 1, 1743, 0, 100000, 'HÃ¡z', 0, 8, -42.65, 1405.46, 1084.42, 0),
(443, 2389.55, -1345.92, 25.077, 1, 2613, 0, 100000, 'hÃ¡z', 0, 8, -42.65, 1405.46, 1084.42, 0),
(444, 2387.69, -1328.25, 25.1242, 1, 2532, 0, 100000, 'HÃ¡z', 0, 8, -42.65, 1405.46, 1084.42, 0),
(445, 2388.22, -1279.61, 25.1291, 1, 1088, 0, 100000, 'HÃ¡z', 0, 8, -42.65, 1405.46, 1084.42, 0),
(446, 2433.66, -1275.03, 24.7567, 1, 924, 0, 100000, 'hÃ¡z', 0, 8, -42.65, 1405.46, 1084.42, 0),
(1245, 2435.4, -1289.02, 25.3479, 1, 3119, 0, 0, 'HÃ¡z', 0, 8, 2365.14, -1135.35, 1050.87, 0),
(448, 2434.1, -1303.3, 24.9942, 1, 1706, 0, 200000, 'HÃ¡z', 0, 9, 83, 1322.48, 1083.86, 0),
(449, 2433.93, -1320.65, 25.3234, 1, 2436, 0, 200000, 'HÃ¡z', 0, 9, 83, 1322.48, 1083.86, 0),
(450, 2439.59, -1338.75, 24.1016, 1, 20, 0, 200000, 'HÃ¡z', 0, 9, 83, 1322.48, 1083.86, 0),
(451, 2439.86, -1357.04, 24.1003, 1, 3071, 0, 200000, 'hÃ¡z', 0, 9, 83, 1322.48, 1083.86, 0),
(1723, 1248.89, -803.607, 84.1406, 4, 1153, 0, 1, 'GarÃ¡zs', 0, 18, 1292.28, 0.033525, 1001.02, 0),
(453, 2023.06, -1053.05, 25.5961, 1, 2923, 0, 10000, 'HÃ¡z', 0, 8, -42.65, 1405.46, 1084.42, 0),
(454, 2035.9, -1059.15, 25.6508, 1, 1302, 0, 10000, 'HÃ¡z', 0, 8, -42.65, 1405.46, 1084.42, 0),
(1705, 2050.77, -1065.65, 25.7836, 1, 1584, 0, 200000, 'HÃ¡z', 0, 5, 226.56, 1114.19, 1080.99, 0),
(456, 2060.99, -1075.32, 25.6851, 1, 24, 0, 150000, 'HÃ¡z', 0, 9, 260.67, 1237.32, 1084.25, 0),
(457, 2075.12, -1082.14, 25.3891, 1, 107, 0, 100000, 'HÃ¡z', 0, 8, -42.65, 1405.46, 1084.42, 0),
(458, 2082.36, -1085.29, 25.519, 1, 166, 0, 100000, 'HÃ¡z', 0, 8, -42.65, 1405.46, 1084.42, 0),
(459, 2094.91, -1091.97, 25.1284, 4, 166, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(460, 2100.3, -1094.39, 25.1566, 4, 1405, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(461, 2016.3, -1737.46, 13.5469, 4, 497, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(462, 2017.99, -1707.92, 13.5469, 4, 2372, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(463, 2027.44, -1648.3, 13.5547, 4, 572, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(1311, 2056.41, -1636.27, 13.5469, 4, 4101, 0, 1, 'BloodsGarÃ¡zs', 0, 2, 613.655, -74.5078, 997.992, 0),
(469, 2016.2, -1717.03, 14.125, 1, 926, 0, 110000, 'HÃ¡z', 0, 8, 2365.14, -1135.35, 1050.87, 0),
(470, 2018.24, -1703.23, 14.2344, 1, 632, 0, 110000, 'HÃ¡z', 0, 8, 2365.14, -1135.35, 1050.87, 0),
(471, 2013.58, -1656.43, 14.1363, 1, 572, 0, 110000, 'HÃ¡z', 0, 8, 2365.14, -1135.35, 1050.87, 0),
(472, 2016.54, -1641.71, 14.1129, 1, 643, 0, 110000, 'HÃ¡z', 0, 8, 2365.14, -1135.35, 1050.87, 0),
(473, 2018.05, -1629.87, 14.0426, 1, 640, 0, 110000, 'HÃ¡z', 0, 8, 2365.14, -1135.35, 1050.87, 0),
(474, 2067.7, -1628.89, 14.2066, 1, 2100, 0, 110000, 'HÃ¡z', 0, 8, 2365.14, -1135.35, 1050.87, 0),
(1825, -2634.37, 1409.75, 906.465, 2, 0, 0, 0, 'Iroda', 0, 1, -2158.81, 643.14, 1052.37, 0),
(476, 2067.56, -1643.75, 14.1363, 1, 345, 0, 110000, 'HÃ¡z', 0, 8, 2365.14, -1135.35, 1050.87, 0),
(477, 2066.74, -1656.57, 14.1328, 1, 368, 0, 110000, 'HÃ¡z', 0, 8, 2365.14, -1135.35, 1050.87, 0),
(1871, 1559.09, -1222.41, 17.4035, 4, 1103, 0, 1, 'LSMC-Garage', 56, 1, 1412.14, -2.28, 1000.92, 0),
(1824, -2634.37, 1409.75, 906.465, 2, 0, 0, 0, 'Iroda', 65, 1, -2158.81, 643.14, 1052.37, 0),
(482, 2505.46, -1688.03, 13.5548, 4, 1130, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(483, 2495.33, -1691.04, 14.7656, 1, 2058, 0, 80000, 'HÃ¡z', 0, 3, 2496.03, -1692.17, 1014.74, 0),
(485, 2514.38, -1691.55, 14.046, 1, 2291, 0, 75000, 'HÃ¡z', 0, 8, -42.65, 1405.46, 1084.42, 0),
(486, 2519.82, -1673.42, 14.6513, 4, 11, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(500, 2469.42, -1646.36, 13.7801, 1, 1129, 0, 75000, 'HÃ¡z', 0, 5, 22.98, 1403.6, 1084.42, 0),
(489, 2524.71, -1658.53, 15.824, 1, 1871, 0, 75000, 'HÃ¡z', 0, 2, 2468.77, -1698.25, 1013.5, 0),
(498, 2486.83, -1644.66, 14.0772, 1, 1552, 0, 85000, 'HÃ¡z', 0, 9, 83, 1322.48, 1083.86, 0),
(493, 2459.44, -1691.66, 13.546, 1, 4186, 0, 80000, 'HÃ¡z', 0, 6, -68.83, 1351.46, 1080.21, 0),
(492, 2523.27, -1679.47, 15.497, 1, 11, 0, 80000, 'HÃ¡z', 0, 9, 260.67, 1237.32, 1084.25, 0),
(1744, -789.104, 510.188, 1367.37, 3, 0, 0, 1, 'FolyosÃ³', 57, 1, 2266.32, 1647.59, 1084.23, 0),
(495, 2513.63, -1650.45, 14.3557, 1, 2409, 0, 75000, 'HÃ¡z', 0, 8, -42.65, 1405.46, 1084.42, 0),
(2, 2244.93, -1663.91, 15.4766, 3, 0, 0, 0, 'Binco', 0, 15, 207.58, -111, 1005.13, 0),
(1859, 2844.77, -1283, 19.7508, 4, 4237, 0, 100000, 'GarÃ¡zs', 0, 1, 1412.14, -2.28, 1000.92, 0),
(1571, 2126.73, -1320.87, 26.6241, 1, 1886, 0, 1, 'HÃ¡z', 0, 6, 234.2, 1063.85, 1084.21, 0),
(507, 1969.25, -1705.31, 15.9688, 1, 3565, 0, 100000, 'HÃ¡z', 0, 8, -42.65, 1405.46, 1084.42, 0),
(508, 1973.29, -1705.48, 15.9688, 1, 2406, 0, 100000, 'HÃ¡z', 0, 8, -42.65, 1405.46, 1084.42, 0),
(513, 1981, -1682.79, 17.0537, 1, 1145, 0, 120000, 'HÃ¡z', 0, 9, 83, 1322.48, 1083.86, 0),
(514, 1974.83, -1671.73, 15.9688, 1, 154, 0, 80000, 'HÃ¡z', 0, 2, 2468.77, -1698.25, 1013.5, 0),
(516, 1969.9, -1671.19, 18.5456, 1, 2524, 0, 80000, 'HÃ¡z', 0, 2, 2468.77, -1698.25, 1013.5, 0),
(518, 2192.4, -1815.22, 13.5469, 1, 1107, 0, 30000, 'HÃ¡z', 0, 5, 2233.57, -1115.08, 1050.88, 0),
(521, 2185.78, -1815.12, 13.5469, 1, 2141, 0, 30000, 'Motelszoba', 0, 5, 2233.57, -1115.08, 1050.88, 0),
(520, 2176.17, -1815.23, 13.5469, 1, 1341, 0, 30000, 'HÃ¡z', 0, 5, 2233.57, -1115.08, 1050.88, 0),
(522, 2168.96, -1815.09, 13.5469, 1, 1343, 0, 30000, 'HÃ¡z', 0, 5, 2233.57, -1115.08, 1050.88, 0),
(523, 2162.73, -1815.23, 13.5469, 1, 1313, 0, 30000, 'HÃ¡z', 0, 5, 2233.57, -1115.08, 1050.88, 0),
(524, 2151.05, -1814.96, 13.5498, 1, 2500, 0, 30000, 'Motelszoba', 0, 5, 2233.57, -1115.08, 1050.88, 0),
(525, 2151.05, -1808.04, 13.5464, 1, 377, 0, 30000, 'Motelszoba', 0, 5, 2233.57, -1115.08, 1050.88, 0),
(526, 2155.92, -1815.22, 13.5469, 1, 2525, 0, 30000, 'HÃ¡z', 0, 5, 2233.57, -1115.08, 1050.88, 0),
(528, 2146.53, -1808.4, 16.1406, 1, 78, 0, 30000, 'Motelszoba', 0, 5, 2233.57, -1115.08, 1050.88, 0),
(529, 2146.47, -1814.99, 16.1406, 1, 1164, 0, 30000, 'Motelszoba', 0, 5, 2233.57, -1115.08, 1050.88, 0),
(1570, 2152, -1819.7, 16.1406, 1, 1468, 0, 100000, 'MotelSzoba', 0, 5, 2233.53, -1115.26, 1050.88, 0),
(531, 2144.96, -1801.78, 16.1406, 1, 2635, 0, 30000, 'HÃ¡z', 0, 5, 2233.57, -1115.08, 1050.88, 0),
(532, 2158.27, -1819.69, 16.1406, 1, 2369, 0, 30000, 'Motelszoba', 0, 5, 2233.57, -1115.08, 1050.88, 0),
(533, 2164.89, -1819.7, 16.1406, 1, 78, 0, 30000, 'Motelszoba', 0, 5, 2233.57, -1115.08, 1050.88, 0),
(534, 2172.29, -1819.61, 16.1406, 1, 651, 0, 30000, 'Motelszoba', 0, 5, 2233.57, -1115.08, 1050.88, 0),
(535, 2140.93, -1801.97, 16.1475, 1, 1389, 0, 30000, 'HÃ¡z', 0, 5, 2233.57, -1115.08, 1050.88, 0),
(536, 2176.49, -1821.59, 16.146, 1, 1426, 0, 30000, 'Motelszoba', 0, 5, 2233.57, -1115.08, 1050.88, 0),
(537, 2176.48, -1828.59, 16.1409, 1, 1128, 0, 30000, 'Motelszoba', 0, 5, 2233.57, -1115.08, 1050.88, 0),
(543, 2164.71, -2163.26, 13.5469, 3, 0, 0, 0, 'Iroda', 4, 3, -2029.61, -119.36, 1035.17, 0),
(1119, 2197.27, -60.708, 28.1535, 1, 2965, 0, 0, 'HÃ¡z', 0, 8, 2365.14, -1135.35, 1050.87, 0),
(555, 2377.11, 75.4297, 27.5755, 4, 2545, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(557, 2377.35, 79.0479, 27.5364, 4, 2545, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(562, 2374.21, 71.0625, 28.4416, 1, 2545, 0, 120000, 'HÃ¡z', 0, 6, 2333, -1077, 1049, 0),
(671, 2203.62, -89.3076, 28.1535, 1, 589, 0, 0, 'HÃ¡z', 0, 8, 2365.14, -1135.35, 1050.87, 0),
(1854, 1205.01, -3.47656, 1000.92, 1, 0, 0, 1, 'Iroda', 65, 3, 965.16, -53.4082, 1001.12, 0),
(1845, 2157.07, -2181.05, 13.5469, 4, 1073, 0, 0, 'GarÃ¡zs', 68, 1, 1412.14, -2.28, 1000.92, 0),
(578, -2026.81, -103.937, 1035.17, 1, 0, 0, 1, 'Ã‰tkezÅ‘', 4, 3, -2029.61, -119.36, 1035.17, 0),
(652, 1173.76, -1361.79, 14.2653, 3, 0, 0, 0, 'LSMC', 6, 10, 362.88, -75.11, 1001.5, 0),
(579, -2026.81, -103.937, 1035.17, 1, 0, 0, 1, 'Ã‰tkezÅ‘', 4, 3, -2029.61, -119.36, 1035.17, 0),
(774, 870.112, -1504.88, 13.3563, 4, 755, 0, 0, 'Butcher', 80000, 2, 613.655, -74.5078, 997.992, 0),
(1914, 1089.44, -638.048, 113.041, 4, 5, 0, 0, 'Petyus', 0, 18, 1292.28, 0.033525, 1001.02, 0),
(595, -2420.16, 969.863, 45.2969, 3, 0, 0, 1, 'Mol', 0, 3, 834.61, 7.54, 1004.18, 0),
(1267, 860.285, -848.25, 77.2972, 4, 3751, 0, 0, 'GarÃ¡zs', 0, 1, 1412.14, -2.28, 1000.92, 0),
(610, 2406.43, 105.49, 27.0878, 4, 88, 0, 0, 'GarÃ¡zs', 0, 2, 613.655, -74.5078, 997.992, 0),
(627, 1393.25, -1631.07, 13.5469, 2, 20, 0, 1, 'Iroda', 11, 3, 390.44, 173.91, 1008.38, 0),
(628, 1355.99, -1673.62, 13.6044, 4, 1422, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(629, 212.158, 188.007, 1003.03, 3, 0, 0, 0, 'GyakorlÃ³', 5, 10, -1128.64, 1066.33, 1345.74, 0),
(630, 212.158, 188.007, 1003.03, 3, 0, 0, 0, 'GyakorlÃ³', 5, 10, -1128.64, 1066.33, 1345.74, 0),
(631, 212.158, 188.007, 1003.03, 3, 0, 0, 1, 'GyakorlÃ³', 5, 10, -1128.64, 1066.33, 1345.74, 0),
(632, 212.158, 188.007, 1003.03, 3, 0, 0, 1, 'GyakorlÃ³', 5, 2, 2541.72, -1303.89, 1025.07, 0),
(633, 212.158, 188.007, 1003.03, 3, 0, 0, 1, 'GyakorlÃ³', 5, 15, 2214.62, -1150.38, 1025.79, 0),
(634, 211.712, 188.292, 1003.03, 3, 0, 0, 1, 'GyakorlÃ³', 5, 10, -1128.64, 1066.33, 1345.74, 0),
(635, 212.327, 188.194, 1003.03, 3, 0, 0, 1, 'GyakorlÃ³', 5, 10, -1128.64, 1066.33, 1345.74, 0),
(636, 212.327, 188.194, 1003.03, 3, 0, 0, 1, '2', 5, 1, 1412.14, -2.28, 1000.92, 0),
(638, 2260.02, -1019.58, 59.2931, 1, 2069, 0, 0, 'HÃ¡z', 0, 10, 24, 1340.33, 1084.37, 0),
(640, 212.281, 187.879, 1003.03, 3, 0, 0, 1, 'GyakorlÃ³', 5, 10, -1128.64, 1066.33, 1345.74, 0),
(641, 212.281, 187.879, 1003.03, 4, 0, 0, 1, 'GyakorlÃ³', 5, 10, -1128.64, 1066.33, 1345.74, 0),
(1862, 2402.47, -1715.35, 14.1328, 1, 1468, 0, 0, 'Jhon', 150000, 2, 446.97, 1397.22, 1084.3, 0),
(1863, 2827.78, -1164.92, 25.044, 4, 1507, 0, 30000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(648, 1022.51, -1122.17, 23.8715, 1, 2852, 0, 0, 'Casino', 0, 10, 2019.02, 1017.93, 996.87, 0),
(1209, 1034.87, -812.88, 101.852, 1, 560, 0, 0, 'Luxus', 0, 9, 83, 1322.48, 1083.86, 0),
(651, 2384.46, -1674.62, 14.7355, 1, 947, 0, 0, '700', 1, 9, 260.67, 1237.32, 1084.25, 0),
(1314, 1446.15, -1468.5, 13.373, 4, 46, 0, 1, 'GarÃ¡zs', 0, 1, 1412.14, -2.28, 1000.92, 0),
(665, 2424.69, -61.8115, 27.4766, 4, 1704, 0, 75000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(1476, 815.229, -1551.2, 13.552, 4, 4265, 0, 0, 'GarÃ¡zs', 0, 1, 1412.14, -2.28, 1000.92, 0),
(659, 870.049, -25.4346, 63.9517, 1, 692, 0, 1, 'Putri', 0, 10, 422.26, 2536.37, 10, 0),
(1123, 1007.47, -664.157, 121.144, 4, 79, 0, 0, 'GarÃ¡zs', 0, 1, 1412.14, -2.28, 1000.92, 0),
(670, 2326.78, -1716.7, 14.2379, 1, 52, 0, 1, 'LakÃ¡s', 7, 8, 2365.14, -1135.35, 1050.87, 0),
(669, 2512.82, -1027.82, 70.0859, 1, 694, 0, 1, 'LakÃ¡s', 7, 5, 318.55, 1114.47, 1083.88, 0),
(1896, 2368.26, -1675.35, 14.1682, 1, 5089, 0, 0, '500', 0, 10, 2270.41, -1210.46, 1047.56, 0),
(1081, 2089.77, -1170.88, 25.5938, 4, 1786, 0, 30000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(683, 1652.84, -1836.9, 13.5463, 4, 1707, 0, 1, 'GarÃ¡zs', 0, 2, 613.655, -74.5078, 997.992, 0),
(685, 2451.57, 57.9277, 27.4833, 4, 2532, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(684, 2447.71, 57.79, 27.4609, 4, 2532, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(1901, 681.609, -474.451, 16.5363, 1, 731, 0, 0, 'Angel\'s', 1, 11, 501.84, -67.84, 998.75, 0),
(1367, 313.47, -121.262, 3.53539, 1, 1744, 0, 0, 'Marlon', 1, 7, 225.71, 1021.44, 1084.01, 0),
(702, 2104.96, -1806.52, 13.5547, 3, 0, 0, 0, 'Ã‰tterem', 0, 17, 377.16, -192.91, 1000.64, 0),
(842, -2026.88, -104.389, 1035.17, 1, 0, 0, 0, 'LSCMMeetingRoom', 3, 3, 965.16, -53.4082, 1001.12, 0),
(700, 875.228, -1513.02, 14.0161, 1, 755, 0, 150000, 'House', 0, 4, -260.78, 1456.73, 1084.36, 0),
(777, 2394.89, -1134.01, 30.7188, 1, 110, 0, 50000, 'AtihÃ¡za', 0, 8, 2365.14, -1135.35, 1050.87, 0),
(710, 2229.53, -1721.79, 13.5664, 3, 0, 0, 0, 'Boxterem', 0, 5, 772.43, -5.19, 1000.72, 0),
(714, 1567.99, -1897.72, 13.5608, 3, 0, 0, 0, 'Boxterem', 0, 1, -794.98, 489.78, 1376.2, 0),
(716, 2628.59, -1068.12, 69.6129, 1, 41, 0, 0, 'HÃ¡z', 21, 8, -42.65, 1405.46, 1084.42, 0),
(776, 1123.38, -2037.16, 69.8872, 3, 0, 0, 0, 'Government', 23, 3, 390.44, 173.91, 1008.38, 0),
(1117, 147.924, -1473.46, 25.2109, 4, 1118, 0, 120000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(724, 2548.95, 25.0166, 27.6756, 1, 2079, 0, 0, 'HÃ¡z', 130000, 8, 2365.14, -1135.35, 1050.87, 0),
(1212, 854.307, -1061.26, 25.1068, 4, 2542, 0, 1, 'GarÃ¡zs', 0, 1, 1412.14, -2.28, 1000.92, 0),
(731, 1867.15, -1885.18, 13.452, 4, 830, 0, 50000, 'GarÃ¡zs', 0, 2, 613.655, -74.5078, 997.992, 0),
(1771, 2445.87, -1762.91, 13.5871, 4, 5226, 0, 0, 'GarÃ¡zs', 69, 2, 613.655, -74.5078, 997.992, 0),
(1435, 2827.75, -1169.83, 25.0345, 4, 5087, 0, 200000, 'GarÃ¡zs', 0, 1, 1412.14, -2.28, 1000.92, 0),
(740, 2827.94, -1196.09, 24.8837, 4, 1353, 0, 25000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(739, 2828.03, -1201.25, 24.7889, 4, 1717, 0, 25000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(743, 2808.12, -1177.1, 25.3735, 1, 1507, 0, 70000, 'GarÃ¡zs', 0, 15, 295.05, 1472.36, 1080.25, 0),
(767, -2721.6, 980.801, 54.4609, 4, 267, 0, 100000, 'GarÃ¡zs', 0, 1, 1412.14, -2.28, 1000.92, 0),
(745, -2710.58, 968.199, 54.4609, 1, 267, 0, 0, 'Frenkiln', 90000, 12, 2324.42, -1149.2, 1050.71, 0),
(1838, 1837.04, -1682.4, 13.3228, 3, 0, 0, 0, 'Alhambra', 0, 17, 493.34, -24.48, 1000.67, 0),
(1195, 979.229, -830.097, 95.7252, 4, 4143, 0, 0, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(770, 2513.36, -27.5312, 28.4416, 1, 195, 0, 120000, 'House', 0, 8, 2365.14, -1135.35, 1050.87, 0),
(779, 1909.96, -1885.44, 13.5094, 4, 683, 0, 50000, 'GarÃ¡zs', 0, 2, 613.655, -74.5078, 997.992, 0),
(789, 2198.36, -1503.96, 23.9593, 4, 3986, 0, 0, 'garÃ¡zs', 0, 2, 613.655, -74.5078, 997.992, 0),
(781, 2262.96, -132.681, 27.4688, 4, 4963, 0, 70000, 'Garage', 0, 2, 613.655, -74.5078, 997.992, 0),
(782, 2150.75, -1671.6, 15.0859, 1, 1005, 0, 0, 'Piru', 9, 3, 2496.03, -1692.17, 1014.74, 0),
(783, 2144.6, -1663.64, 15.0859, 1, 1005, 0, 0, 'Piru', 9, 4, 261.14, 1284.56, 1080.25, 0),
(788, 893.848, -1520.4, 13.3329, 4, 857, 0, 0, 'GarÃ¡zs', 0, 18, 1292.28, 0.033525, 1001.02, 0),
(794, 1284.79, -1090.2, 28.2578, 1, 916, 0, 0, 'Boscorelli', 100000, 5, 226.56, 1114.19, 1080.99, 0),
(793, -2455.37, 503.774, 30.0781, 1, 675, 0, 0, 'LCN', 24, 5, 1260.84, -785.42, 1091.9, 0),
(798, 2360.27, -1796.11, 13.5469, 1, 1863, 0, 0, 'hÃ¡z', 16, 6, 2333, -1077, 1049, 0),
(797, 2380.2, -1785.73, 13.5469, 1, 1552, 0, 0, 'hÃ¡z', 16, 5, 318.55, 1114.47, 1083.88, 0),
(802, 2726.72, -2000.54, 13.5472, 4, 2436, 0, 0, 'garage', 0, 1, 1412.14, -2.28, 1000.92, 0),
(806, 2549.38, -1032.17, 69.5788, 1, 20, 0, 1, 'Dimi', 0, 8, -42.65, 1405.46, 1084.42, 0),
(807, 2579.59, -1033.2, 69.5798, 1, 1746, 0, 1, 'LakÃ¡s', 0, 8, -42.65, 1405.46, 1084.42, 0),
(808, 2499.73, -1065.35, 70.2359, 1, 697, 0, 1, 'LakÃ¡s', 0, 8, -42.65, 1405.46, 1084.42, 0),
(809, 2576.68, -1070.56, 69.8322, 1, 110, 0, 1, 'Kocsma', 7, 18, -229.17, 1401.14, 27.76, 0),
(810, -2662.1, 876.721, 79.7738, 1, 3271, 0, 1, 'RussianGurdian', 0, 12, 2324.42, -1149.2, 1050.71, 0),
(817, -2680.28, 867.782, 76.318, 4, 3271, 0, 120000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(1672, 937.624, -848.183, 93.6609, 1, 3323, 0, 1, 'HÃ¡z', 0, 6, 234.2, 1063.85, 1084.21, 0),
(1248, 768.135, -504.282, 18.0129, 1, 4946, 0, 1, 'HÃ¡z', 0, 5, 226.56, 1114.19, 1080.99, 0),
(820, 2561.08, -1034.67, 69.5753, 1, 2586, 0, 1, 'LakÃ¡s', 0, 8, -42.65, 1405.46, 1084.42, 0),
(1250, 646.049, -1117.09, 44.207, 1, 880, 0, 0, 'HÃ¡zs', 0, 5, 226.56, 1114.19, 1080.99, 0),
(1251, 267.813, -55.5254, 2.77721, 1, 4243, 0, 200000, 'LakÃ¡s', 0, 5, 226.56, 1114.19, 1080.99, 0),
(825, 1945.51, 2268.11, 28.8623, 1, 20, 0, 1, 'Meetingroom', 0, 1, -2158.81, 643.14, 1052.37, 0),
(1247, 898.343, -1474.08, 13.8526, 1, 1922, 0, 0, 'Hause', 0, 9, 83, 1322.48, 1083.86, 0),
(1877, 2470.27, -1295.49, 30.2332, 1, 5068, 0, 0, 'Smith_Rezidencia', 0, 8, 2365.14, -1135.35, 1050.87, 0),
(832, 2244.53, -1637.64, 16.2379, 1, 2617, 0, 1, 'Binco', 0, 1, 223.22, 1287.17, 1082.14, 0),
(835, 745.033, -591.138, 18.0129, 1, 800, 0, 0, 'Jerold', 0, 2, 2237.52, -1081.64, 1049.02, 0),
(843, -2026.88, -104.389, 1035.17, 1, 0, 0, 0, 'LSCMMeetingRoom', 3, 3, 965.16, -53.4082, 1001.12, 0),
(892, 1833.21, -1125.49, 24.6721, 3, 0, 0, 0, 'LSCMMeetingRoom', 0, 3, -2029.61, -119.36, 1035.17, 0),
(844, -2026.88, -104.389, 1035.17, 1, 0, 0, 0, 'LSCMMeetingRoom', 3, 3, 965.16, -53.4082, 1001.12, 0),
(845, -2026.95, -104.576, 1035.17, 1, 0, 0, 0, 'LSCMMeetingRoom', 3, 3, 965.16, -53.4082, 1001.12, 0),
(902, 503.264, -11.7686, 1000.68, 3, 0, 0, 0, 'TESZT2', 0, 17, 493.34, -24.48, 1000.67, 0),
(849, -1616.76, 687.508, 7.1875, 3, 0, 0, 0, 'SASD', 0, 10, 246.37, 107.51, 1003.21, 0),
(1850, 1204.72, 12.665, 1000.92, 1, 0, 0, 0, 'Private', 65, 3, 975.26, -8.64, 1001.14, 0),
(852, 2189.81, -1414.67, 25.5391, 4, 4492, 0, 0, 'GarÃ¡zs', 0, 2, 613.655, -74.5078, 997.992, 0),
(856, 1934.4, -1882.91, 13.5333, 4, 23, 0, 50000, 'hocstongarage', 0, 2, 613.655, -74.5078, 997.992, 0),
(1560, -2161.21, -2544.84, 31.8163, 1, 823, 0, 1, 'HÃ¡z', 0, 6, 234.2, 1063.85, 1084.21, 0),
(1883, 2065.21, -1703.5, 14.1484, 1, 2828, 0, 0, 'Vietnam', 0, 10, 2270.41, -1210.46, 1047.56, 0),
(1562, 252.284, -121.199, 3.53539, 1, 1886, 0, 1, 'HÃ¡z', 0, 15, 295.05, 1472.36, 1080.25, 0),
(860, 900.815, -1447.25, 14.2764, 1, 949, 0, 0, 'SuttogÃ³Maffia\'sBase', 0, 12, 2324.42, -1149.2, 1050.71, 0),
(864, 2645.12, -2034.4, 13.554, 4, 1653, 0, 0, 'GarÃ¡zs', 0, 18, 1292.28, 0.033525, 1001.02, 0),
(1856, 1204.69, 11.5283, 1000.92, 1, 0, 0, 1, 'Iroda', 65, 3, 965.16, -53.4082, 1001.12, 0),
(865, 2637.08, -1991.7, 14.324, 1, 1289, 0, 0, 'LuigiKuckÃ³ja', 0, 15, 295.05, 1472.36, 1080.25, 0),
(866, 2650.57, -2021.77, 14.1766, 1, 1653, 0, 0, 'ProXiiSzentÃ©lye', 0, 15, 295.05, 1472.36, 1080.25, 0),
(868, 2635.55, -2012.83, 14.1443, 1, 434, 0, 0, 'MarioKuckÃ³ja', 0, 15, 295.05, 1472.36, 1080.25, 0),
(1196, 989.387, -827.701, 95.4686, 1, 4143, 0, 0, 'JackRezidencia', 0, 9, 2317.81, -1026.55, 1050.21, 0),
(1799, 1038.24, -1340.6, 13.7435, 3, 0, 0, 0, 'Quick', 0, 10, 362.88, -75.11, 1001.5, 0),
(874, 904.044, -1455.02, 13.0633, 4, 949, 0, 0, 'GarÃ¡zs', 0, 1, 1412.14, -2.28, 1000.92, 0),
(879, 1673.98, -2122.16, 14.146, 1, 1905, 0, 0, 'BluffsHouse12', 0, 9, 260.67, 1237.32, 1084.25, 0),
(887, -2670.92, 929.435, 79.7031, 1, 1066, 0, 0, 'HanaKastÃ©lya', 0, 6, 234.2, 1063.85, 1084.21, 0),
(883, -2664.91, 913.505, 79.6749, 4, 1066, 0, 0, 'HannaMagÃ¡nGarÃ¡zsa', 0, 2, 613.655, -74.5078, 997.992, 0),
(884, 1431.66, -928.077, 37.1428, 4, 24, 0, 0, '0', 0, 1, 1412.14, -2.28, 1000.92, 0),
(885, 1440.59, -926.669, 39.6406, 1, 24, 0, 0, '0', 0, 10, 24, 1340.33, 1084.37, 0),
(886, 2209.69, 114.362, 27.158, 4, 5148, 0, 0, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(893, 1974.78, -1671.71, 18.5456, 1, 651, 0, 0, '0', 0, 1, 223.22, 1287.17, 1082.14, 0),
(963, 808.861, -759.042, 76.5314, 1, 988, 0, 0, 'HÃ¡z', 0, 5, 226.56, 1114.19, 1080.99, 0),
(890, 813.56, -767.811, 76.7399, 4, 988, 0, 0, 'BeanGarÃ¡zs', 0, 2, 613.655, -74.5078, 997.992, 0),
(903, 503.264, -11.7686, 1000.68, 3, 0, 0, 0, 'TESZT2', 0, 17, 493.34, -24.48, 1000.67, 0),
(904, 503.264, -11.7686, 1000.68, 3, 0, 0, 0, 'TESZT2', 0, 17, 493.34, -24.48, 1000.67, 0),
(1385, 2457.42, -1901.98, 13.5469, 4, 3879, 0, 0, 'Crip\'S', 0, 3, 612.769, -124.025, 997.992, 0),
(1384, 2510.57, -1132.58, 41.6207, 1, 706, 0, 55000, 'JonatanHÃ¡z', 0, 10, 2259.68, -1136.09, 1050.63, 0),
(915, 1817.09, -1146.48, 23.9544, 4, 887, 0, 0, 'LSCM.IDG.GarÃ¡zs', 3, 18, 1292.28, 0.033525, 1001.02, 0),
(940, 1795.27, -2146.89, 13.5619, 4, 2827, 0, 0, 'GarÃ¡zs', 0, 2, 613.655, -74.5078, 997.992, 0),
(919, 1804.04, -2124.24, 13.9424, 1, 1387, 0, 0, 'LakÃ¡s', 0, 12, 2324.42, -1149.2, 1050.71, 0),
(1122, 1012.07, -660.588, 121.14, 4, 79, 0, 0, 'GarÃ¡zs', 0, 1, 1412.14, -2.28, 1000.92, 0),
(1546, 595.298, -1250.44, 18.2804, 2, 4444, 0, 1, 'Club', 0, 3, -2636.77, 1402.6, 906.46, 0),
(1545, 1465.1, -1051.46, 24.0156, 2, 2531, 0, 1, 'RamsayClub', 0, 17, 493.34, -24.48, 1000.67, 0),
(927, 2442.17, -1403.39, 24, 1, 694, 0, 0, 'BPSNKocsma', 32, 18, -229.17, 1401.14, 27.76, 0),
(928, 2495.15, -1409.31, 28.8394, 1, 694, 0, 0, 'BPSN', 32, 15, 295.05, 1472.36, 1080.25, 0),
(929, 776.555, -1036.14, 24.2791, 3, 0, 0, 0, 'OlaszÃ‰tterem', 24, 1, -794.98, 489.78, 1376.2, 0),
(1791, 2070.84, -1793.89, 13.5533, 3, 0, 0, 0, 'Barber', 0, 3, 418.75, -84.31, 1001.8, 0),
(957, 1684.49, -2098.62, 13.8343, 1, 2460, 0, 0, 'HÃ¡z', 0, 6, 2196.85, -1204.4, 1049, 0),
(958, 1698.76, -2092.86, 13.5469, 4, 2460, 0, 0, 'GarÃ¡zs', 0, 1, 1412.14, -2.28, 1000.92, 0),
(1788, 2420.01, -1508.93, 24, 3, 0, 0, 0, 'Cluck\'n\'Bell', 0, 9, 364.95, -11.6, 1001.85, 0),
(955, 2256.94, -1644.56, 15.5198, 1, 1389, 0, 0, 'HÃ¡z', 7, 6, 2333, -1077, 1049, 0),
(976, 2480.34, -24.7666, 27.5155, 4, 1326, 0, 0, 'GarÃ¡zs', 0, 1, 1412.14, -2.28, 1000.92, 0),
(1857, 1204.43, 11.0127, 1007.92, 1, 0, 0, 1, 'Iroda', 65, 3, 965.16, -53.4082, 1001.12, 0),
(960, 1972.57, -1621.6, 15.9688, 4, 643, 0, 0, 'GarÃ¡zs', 0, 1, 1412.14, -2.28, 1000.92, 0),
(962, 1761.19, -2125.09, 14.0566, 1, 3267, 0, 0, 'HÃ¡z', 0, 2, 446.97, 1397.22, 1084.3, 0),
(965, 405.946, -1264.8, 50.2794, 4, 675, 0, 0, 'GarÃ¡zs', 0, 1, 1412.14, -2.28, 1000.92, 0),
(970, 1143.38, 6.10742, 1000.68, 1, 0, 0, 0, 'asd', 18, 9, 83, 1322.48, 1083.86, 0),
(971, 1143.49, 6.28809, 1000.68, 1, 0, 0, 0, 'Lakatos', 0, 12, 1133.25, -15.26, 1000.67, 0),
(974, 985.828, -689.209, 123.973, 1, 2, 0, 0, 'Lakatos', 0, 9, 83, 1322.48, 1083.86, 0),
(975, 1133.04, -10.6641, 1000.68, 1, 0, 0, 0, 'Lakatos', 0, 12, 1133.25, -15.26, 1000.67, 0),
(979, 1415.76, 261.611, 19.5535, 2, 859, 0, 0, 'Mongols', 0, 11, 501.84, -67.84, 998.75, 0),
(978, 2520.75, -1197.68, 56.5774, 1, 1686, 0, 0, 'HÃ¡z', 0, 12, 2324.42, -1149.2, 1050.71, 0),
(1748, -789.345, 509.727, 1367.37, 3, 0, 0, 1, 'AjtÃ³', 57, 1, 2266.32, 1647.59, 1084.23, 0),
(985, 758.624, 375.111, 23.1952, 1, 86, 0, 0, 'HÃ¡z', 0, 8, -42.65, 1405.46, 1084.42, 0),
(984, -2774.65, -405.13, 7.20932, 4, 52, 0, 0, 'GarÃ¡zs', 0, 1, 1412.14, -2.28, 1000.92, 0),
(1169, 1959.1, -1560.75, 13.596, 1, 1746, 0, 0, 'House', 9, 5, 318.55, 1114.47, 1083.88, 0),
(987, 2271.12, 1652.51, 1084.23, 3, 0, 0, 0, 'Szoba', 10, 5, 2233.57, -1115.08, 1050.88, 0),
(988, 2271.12, 1652.51, 1084.23, 3, 0, 0, 0, 'Szoba', 10, 5, 2233.57, -1115.08, 1050.88, 0),
(1268, 859.03, -827.05, 89.5017, 1, 3751, 0, 0, 'HÃ¡z', 0, 9, 83, 1322.48, 1083.86, 0),
(1913, 1094.93, -647.291, 113.648, 1, 5, 0, 0, 'Petyus', 0, 6, 297.05, -111.79, 1001.51, 0),
(992, 2264.4, 1619.41, 1090.45, 1, 0, 0, 0, 'Szoba5', 10, 10, 2270.41, -1210.46, 1047.56, 0),
(994, -2681.21, -319.279, 14.5174, 3, 0, 0, 0, 'Szoba5', 10, 10, 2270.41, -1210.46, 1047.56, 0);
INSERT INTO `interiors` (`id`, `x`, `y`, `z`, `type`, `owner`, `locked`, `cost`, `name`, `faction`, `interior`, `interiorx`, `interiory`, `interiorz`, `dimension`) VALUES
(995, -2735.48, -368.619, 9.69064, 3, 0, 0, 0, 'Szoba6', 10, 6, 234.2, 1063.85, 1084.21, 0),
(1842, 2495.83, -1759.29, 13.5469, 1, 5226, 0, 0, 'Nightclub', 62, 2, 1204.81, -13.6, 1000.92, 0),
(1817, 2062.92, -1897.58, 13.5538, 3, 0, 0, 0, 'Elektronics', 0, 6, -2240.3, 128.586, 1035.42, 0),
(1002, -1865.44, -1622.07, 21.75, 3, 0, 0, 0, 'GyÃ¡r', 0, 2, 2541.72, -1303.89, 1025.07, 0),
(1008, 1109.2, -732.616, 100.429, 4, 2851, 0, 0, 'GarÃ¡zs', 0, 2, 613.655, -74.5078, 997.992, 0),
(1882, 2519.1, -1113, 56.5926, 1, 718, 0, 0, 'Jhon', 0, 2, 226.48, 1239.87, 1082.14, 0),
(1287, -2706.79, 866.811, 70.7031, 1, 1217, 0, 0, 'HÃ¡z', 0, 9, 2317.81, -1026.55, 1050.21, 0),
(1016, 875.825, -1565.02, 13.5331, 3, 0, 0, 0, 'Hobbibolt', 0, 6, -2240.3, 128.586, 1035.42, 0),
(1019, 2756.16, -1182.81, 69.4035, 1, 2466, 0, 0, 'HÃ¡z', 0, 12, 2324.42, -1149.2, 1050.71, 0),
(1034, 1969.98, -1672.43, 15.9688, 1, 3260, 0, 0, 'HÃ¡z', 0, 2, 2468.77, -1698.25, 1013.5, 0),
(1021, 2572.4, -1091.75, 67.2257, 1, 1620, 0, 0, 'HÃ¡z', 0, 1, 223.22, 1287.17, 1082.14, 0),
(1023, 2444.96, -1421.65, 23.9922, 4, 823, 0, 0, 'GarÃ¡zs', 0, 18, 1292.28, 0.033525, 1001.02, 0),
(1024, -2655.32, 986.637, 64.9913, 1, 2197, 0, 0, 'HÃ¡z', 0, 12, 2324.42, -1149.2, 1050.71, 0),
(1025, -2664.56, 989.321, 64.9037, 4, 2197, 0, 0, 'GarÃ¡zs', 0, 2, 613.655, -74.5078, 997.992, 0),
(1026, 1338.28, 325.203, 20.0715, 4, 4387, 0, 0, 'GarÃ¡zs', 0, 18, 1292.28, 0.033525, 1001.02, 0),
(1216, 1497.05, -687.898, 95.5633, 1, 1886, 0, 1, 'LuxushÃ¡z', 0, 7, 225.71, 1021.44, 1084.01, 0),
(1828, -2634.28, 1409.68, 906.465, 1, 0, 0, 0, 'Iroda', 65, 1, -2158.81, 643.14, 1052.37, 0),
(1036, 2385.4, -1711.66, 14.2422, 1, 1519, 0, 0, 'HÃ¡z', 0, 2, 446.97, 1397.22, 1084.3, 0),
(1246, 762.906, -506.445, 17.3432, 4, 4946, 0, 1, 'GarÃ¡zs', 0, 2, 613.655, -74.5078, 997.992, 0),
(1249, 890.423, -1476.91, 13.0886, 4, 231, 0, 0, 'Garage', 0, 3, 612.769, -124.025, 997.992, 0),
(6, 1219.03, -1812.6, 16.5938, 3, 0, 0, 1, 'AutÃ³siskola', 0, 3, 1494.28, 1303.91, 1093.28, 0),
(1042, 1241.95, -1076.54, 31.5547, 1, 733, 0, 0, 'HÃ¡z', 0, 5, 226.56, 1114.19, 1080.99, 0),
(1045, 2296.58, -1882.01, 14.2344, 1, 173, 0, 0, 'VSCHouse', 0, 2, 2468.77, -1698.25, 1013.5, 0),
(1050, 1247.46, -1067.69, 29.1772, 4, 733, 0, 0, 'GarÃ¡zs', 0, 2, 613.655, -74.5078, 997.992, 0),
(1049, 1237.01, -1085.57, 29.1747, 4, 733, 0, 0, 'GarÃ¡zs', 0, 2, 613.655, -74.5078, 997.992, 0),
(1444, 2551.22, 57.2363, 27.6756, 1, 2439, 0, 400000, 'HÃ¡z.', 0, 2, 446.97, 1397.22, 1084.3, 0),
(1875, 2469.1, -1278.3, 30.3664, 1, 215, 0, 0, 'Smith_Rezidencia', 0, 8, 2365.14, -1135.35, 1050.87, 0),
(1867, 1808.34, -1433.34, 13.4297, 4, 5305, 0, 30000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(1067, 2395.31, 2467.84, 69.4657, 3, 0, 0, 0, 'Szoba', 0, 1, 223.22, 1287.17, 1082.14, 0),
(1069, 2401.02, 2460.33, 69.4657, 3, 0, 0, 0, 'Szoba2', 0, 1, 223.22, 1287.17, 1082.14, 0),
(1068, 2397.5, 2463.5, 69.4657, 3, 0, 0, 0, 'Szoba1', 0, 1, 223.22, 1287.17, 1082.14, 0),
(1070, 2406.72, 2461.4, 69.4657, 3, 0, 0, 0, 'Szoba3', 0, 1, 223.22, 1287.17, 1082.14, 0),
(1071, 2405.56, 2455.75, 69.4657, 3, 0, 0, 0, 'Szoba4', 0, 1, 223.22, 1287.17, 1082.14, 0),
(1072, 2401.28, 2453.97, 69.4657, 3, 0, 0, 0, 'Szoba5', 0, 1, 223.22, 1287.17, 1082.14, 0),
(1075, 2398.06, 2449.93, 69.4657, 3, 0, 0, 0, 'Szoba7', 0, 1, 223.22, 1287.17, 1082.14, 0),
(1074, 2398.77, 2453.81, 69.4657, 3, 0, 0, 0, 'Szoba6', 0, 1, 223.22, 1287.17, 1082.14, 0),
(1076, 2404.17, 2449.27, 69.4657, 3, 0, 0, 0, 'Szoba8', 0, 1, 223.22, 1287.17, 1082.14, 0),
(1077, 2408.22, 2450.01, 69.4657, 3, 0, 0, 0, 'Szoba9', 0, 1, 223.22, 1287.17, 1082.14, 0),
(1767, 228.193, -1405.09, 51.6094, 1, 597, 0, 1000000, 'HÃ¡z', 0, 7, 225.71, 1021.44, 1084.01, 0),
(1372, 1083.04, -1226.53, 15.8203, 1, 597, 0, 600000, 'Iroda', 0, 3, 1494.28, 1303.91, 1093.28, 0),
(1369, 242.389, 1038.12, 1088.3, 1, 0, 0, 1, 'asdasd', 1, 13, -2043.97, 172.932, 28.835, 0),
(1368, 317.55, -127.284, 2.41792, 4, 1744, 0, 0, 'Marlon', 1, 1, 1412.14, -2.28, 1000.92, 0),
(1583, 2433.62, -8.58008, 26.4917, 4, 3013, 0, 1, 'GarÃ¡zs', 0, 1, 1412.14, -2.28, 1000.92, 0),
(1264, 328.711, -1512.79, 36.0391, 3, 0, 0, 0, 'LCN-Hotel', 24, 18, 1726.86, -1638.05, 20.22, 0),
(1755, 2851.77, -1532.51, 11.0938, 3, 0, 0, 0, 'Los_Santos_County_Sheriff_Department', 54, 10, 246.37, 107.51, 1003.21, 0),
(1819, 2306.91, -1679.12, 14.3316, 1, 5193, 0, 0, 'House', 0, 9, 260.67, 1237.32, 1084.25, 0),
(1822, -2634.37, 1409.75, 906.465, 1, 0, 0, 0, 'Iroda', 65, 1, -2158.81, 643.14, 1052.37, 0),
(1823, -2634.37, 1409.75, 906.465, 2, 0, 0, 0, 'Iroda', 65, 1, -2158.81, 643.14, 1052.37, 0),
(1769, 1653.88, -1655.2, 22.5156, 3, 0, 0, 0, 'Los_Santos_News', 63, 3, 289.77, 171.74, 1007.17, 0),
(1750, -789.369, 509.842, 1367.37, 3, 0, 0, 1, 'Iroda', 57, 3, 965.16, -53.4082, 1001.12, 0),
(1749, -789.369, 509.842, 1367.37, 3, 0, 0, 1, 'Iroda', 57, 3, 965.16, -53.4082, 1001.12, 0),
(1747, -789.345, 509.727, 1367.37, 3, 0, 0, 1, 'FolyosÃ³', 57, 1, 2266.32, 1647.59, 1084.23, 0),
(1186, 818.2, -509.479, 18.0129, 1, 3716, 0, 200000, 'HÃ¡z', 0, 15, 295.05, 1472.36, 1080.25, 0),
(1187, 827.259, -494.396, 17.3281, 4, 3716, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(1188, 2177.1, -1311.04, 23.9844, 3, 0, 0, 0, 'Kocsma', 16, 11, 501.84, -67.84, 998.75, 0),
(1201, 766.585, -556.125, 18.0129, 1, 3503, 0, 150000, 'HÃ¡z', 0, 15, 295.05, 1472.36, 1080.25, 0),
(1202, 771.987, -552.981, 17.3432, 4, 3503, 0, 70000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(1881, 750.361, -553.592, 17.3432, 4, 1264, 0, 0, 'Garage', 0, 2, 613.655, -74.5078, 997.992, 0),
(1194, 736.81, -556.417, 18.0129, 1, 1264, 0, 150000, 'HÃ¡z', 0, 15, 295.05, 1472.36, 1080.25, 0),
(1258, 785.401, -826.208, 70.2896, 1, 417, 0, 1000000, 'LuxusHÃ¡z', 1, 5, 226.56, 1114.19, 1080.99, 0),
(1318, 2231.64, 165.688, 27.4838, 4, 250, 0, 1, 'GarÃ¡zs', 0, 2, 613.655, -74.5078, 997.992, 0),
(1427, 865.375, -712.444, 105.68, 4, 1635, 0, 200000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(1221, 251.075, -1359.68, 53.1094, 4, 1153, 0, 0, 'GarÃ¡zs', 0, 1, 1412.14, -2.28, 1000.92, 0),
(1224, 255.033, -1366.82, 53.1094, 1, 5099, 0, 0, 'BoxosTiberia', 0, 7, 225.71, 1021.44, 1084.01, 0),
(1230, 795.068, -506.501, 18.0129, 1, 4003, 0, 0, 'HÃ¡z', 1, 1, 223.22, 1287.17, 1082.14, 0),
(1231, 786.44, -495.601, 17.3359, 4, 4003, 0, 0, 'GarÃ¡zs', 1, 3, 612.769, -124.025, 997.992, 0),
(1758, 2847.3, -1309.57, 14.7266, 1, 4237, 0, 1, 'HÃ¡z', 0, 5, 226.56, 1114.19, 1080.99, 0),
(1897, 2310.02, -1643.57, 14.827, 2, 5089, 0, 0, 'PUB', 58, 11, 501.84, -67.84, 998.75, 0),
(1742, 1286.08, -1329.21, 13.5517, 2, 5091, 0, 1, 'Pergola', 57, 1, -794.98, 489.78, 1376.2, 0),
(1831, -2649.38, 1407.28, 906.277, 3, 0, 0, 0, 'Iroda', 65, 1, -2158.81, 643.14, 1052.37, 0),
(1243, 2486.49, -2021.55, 13.9988, 1, 2439, 0, 0, 'HÃ¡z', 43, 8, 2365.14, -1135.35, 1050.87, 0),
(1244, 2508.03, -2021.05, 14.2101, 1, 3722, 0, 0, 'Hause', 43, 8, -42.65, 1405.46, 1084.42, 0),
(1252, 278.347, -54.4434, 1.57812, 4, 4243, 0, 75000, 'KisGarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(1254, 743.142, -509.957, 18.0129, 1, 3658, 0, 1, 'MÃ¡ndiHouse', 0, 5, 226.56, 1114.19, 1080.99, 0),
(1255, 752.199, -495.38, 17.3281, 4, 3658, 0, 1, 'KÃ¶zepesGarÃ¡zs', 0, 2, 613.655, -74.5078, 997.992, 0),
(1256, 742.96, -495.475, 18.0129, 1, 3658, 0, 1, 'MÃ¡ndihouse', 0, 1, 223.22, 1287.17, 1082.14, 0),
(1269, 2262.32, -1930.68, 12.8805, 4, 3521, 0, 200000, 'GarÃ¡zy', 0, 2, 613.655, -74.5078, 997.992, 0),
(1270, 2261.42, -1906.49, 14.9375, 1, 3521, 0, 100000, 'HÃ¡z', 0, 2, 446.97, 1397.22, 1084.3, 0),
(1652, 994.317, -1295.58, 13.5469, 2, 195, 0, 0, 'AutÃ³ker', 0, 3, 1494.28, 1303.91, 1093.28, 0),
(1273, 973.363, -1257.39, 16.9402, 4, 147, 0, 0, 'Nagy', 1, 1, 1412.14, -2.28, 1000.92, 0),
(1274, 2140.29, -1083.26, 24.4707, 1, 1267, 0, 200000, 'HÃ¡z', 0, 2, 2237.52, -1081.64, 1049.02, 0),
(1275, 2188.94, -1081.39, 43.8335, 1, 1886, 0, 200000, 'HÃ¡z', 0, 1, 2218.24, -1076.27, 1050.48, 0),
(1522, 2189.88, -1103.35, 24.7896, 4, 2564, 0, 1, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(1277, 2198.1, -1105.51, 25.2137, 4, 5213, 0, 200000, 'GarÃ¡zs', 0, 2, 613.655, -74.5078, 997.992, 0),
(1278, 2207.8, -1100.24, 31.5547, 1, 3043, 0, 250000, 'HÃ¡z', 0, 5, 22.98, 1403.6, 1084.42, 0),
(1279, 2049.17, -986.956, 44.6568, 1, 590, 0, 250000, 'HÃ¡z', 0, 5, 22.98, 1403.6, 1084.42, 0),
(1844, 2059.3, -985.715, 46.6589, 4, 590, 0, 0, 'GarÃ¡zs', 0, 2, 613.655, -74.5078, 997.992, 0),
(1746, -789.409, 510.347, 1367.37, 3, 0, 0, 1, 'FolyosÃ³', 57, 1, 2266.32, 1647.59, 1084.23, 0),
(1887, -283.1, -2174.58, 28.6631, 1, 804, 0, 1, 'Kocsma', 0, 1, 681.7, -451.37, -25.61, 0),
(1301, 2447.61, 18.8584, 27.6835, 1, 149, 0, 140000, 'HÃ¡z', 0, 2, 266.56, 305.02, 999.14, 0),
(1302, -217.398, 1402.7, 27.7734, 1, 0, 0, 0, 'PihenÅ‘', 36, 1, 223.22, 1287.17, 1082.14, 0),
(1894, -107.532, -219.729, 2.04663, 1, 5095, 0, 1, 'GyÃ¡r', 0, 1, 964.94, 2159.97, 1011.03, 0),
(1310, -256.814, -2191.38, 28.9898, 1, 466, 0, 1, 'HellsAngels', 0, 1, 223.22, 1287.17, 1082.14, 0),
(1313, 2116.81, -1058.64, 25.7327, 4, 3123, 0, 100000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(1851, 1205.04, 12.6641, 1000.92, 1, 0, 0, 0, 'Private', 65, 3, 975.26, -8.64, 1001.14, 0),
(1414, 1051.44, -644.562, 120.117, 1, 2747, 0, 0, 'JeroldMagÃ¡nBirtok.', 0, 6, 234.2, 1063.85, 1084.21, 0),
(1338, 2479.59, 95.249, 27.6835, 1, 3838, 0, 1, 'HÃ¡z', 0, 8, -42.65, 1405.46, 1084.42, 0),
(1416, 784.894, -760.358, 73.5607, 1, 988, 0, 10000, 'Sum1', 0, 8, 2807.66, -1174.54, 1025.57, 0),
(1826, -2639.23, 1407.49, 906.461, 2, 0, 0, 0, 'Iroda', 0, 1, -2158.81, 643.14, 1052.37, 0),
(1813, 2331.32, -37.8594, 26.4844, 3, 0, 0, 0, 'Sure', 0, 10, 6.05, -31.27, 1003.54, 0),
(1341, 2440.53, -1056.67, 54.7387, 1, 4561, 0, 30000, 'HÃ¡z', 0, 6, -68.83, 1351.46, 1080.21, 0),
(1360, -2572.2, 1147.98, 55.7266, 4, 4594, 0, 1, 'GarÃ¡zs', 0, 1, 1412.14, -2.28, 1000.92, 0),
(1342, 162.03, -1456.37, 32.845, 1, 157, 0, 1, 'HÃ¡z', 0, 7, 225.71, 1021.44, 1084.01, 0),
(1343, 1410.86, -921.537, 38.4219, 1, 1433, 0, 1, 'HÃ¡z', 0, 7, 225.71, 1021.44, 1084.01, 0),
(1353, 1676.11, -1462.4, 13.5538, 1, 2531, 0, 0, 'HÃ¡z', 0, 7, 225.71, 1021.44, 1084.01, 0),
(1830, -2634.42, 1409.67, 906.465, 3, 0, 0, 0, 'Iroda', 65, 1, -2158.81, 643.14, 1052.37, 0),
(1829, -2634.42, 1409.67, 906.465, 1, 0, 0, 0, 'Iroda', 65, 1, -2158.81, 643.14, 1052.37, 0),
(1354, -1438.7, -1544.84, 102.258, 1, 2439, 0, 20000, 'HÃ¡z', 0, 7, 225.71, 1021.44, 1084.01, 0),
(1355, -1448.21, -1523.17, 101.758, 4, 2439, 0, 150000, 'GarÃ¡zs', 0, 1, 1412.14, -2.28, 1000.92, 0),
(1357, -1447.45, -1500.13, 101.758, 4, 2439, 0, 50000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(1359, 2514.08, -1468.13, 24.0111, 1, 2112, 0, 1, 'HÃ¡z', 0, 18, -229.17, 1401.14, 27.76, 0),
(1756, -790.939, 506.911, 1367.37, 3, 0, 0, 1, 'Teszt', 57, 3, 965.16, -53.4082, 1001.12, 0),
(1751, -789.369, 509.842, 1367.37, 3, 0, 0, 1, 'Iroda', 57, 3, 965.16, -53.4082, 1001.12, 0),
(1365, 1845.55, -1884.13, 13.4309, 4, 3452, 0, 100000, 'GarÃ¡zs', 0, 2, 613.655, -74.5078, 997.992, 0),
(1890, -49.8525, -270.501, 6.63319, 1, 5100, 0, 0, 'Vojtek', 0, 3, -2636.77, 1402.6, 906.46, 0),
(1395, 725.759, -1440.02, 13.5391, 1, 1153, 0, 1, '1', 0, 3, 235.44, 1186.83, 1080.25, 0),
(1573, 2354.51, -1511.49, 24, 2, 173, 0, 0, 'Sofa', 0, 17, 377.16, -192.91, 1000.64, 0),
(1399, 2308.8, -1715.97, 14.6496, 1, 4125, 0, 250000, 'HÃ¡z', 0, 8, 2365.14, -1135.35, 1050.87, 0),
(1401, 2228.21, -2063.75, 13.5469, 4, 2718, 0, 200000, 'GarÃ¡zs', 0, 1, 1412.14, -2.28, 1000.92, 0),
(1418, 2807.59, -1165.6, 1025.57, 1, 0, 0, 100, 'Sum1', 0, 6, 343.98, 305.14, 999.14, 0),
(1533, 1290.73, -1161.26, 23.961, 1, 1605, 0, 0, 'Iroda.', 0, 18, 1292.28, 0.033525, 1001.02, 0),
(1419, 2807.59, -1165.6, 1025.57, 1, 0, 0, 100, 'Sum1', 0, 6, 343.98, 305.14, 999.14, 0),
(1420, 2807.47, -1167.03, 1025.57, 1, 0, 0, 100, 'Sum1', 0, 6, 343.98, 305.14, 999.14, 0),
(1421, 2809.19, -1169.48, 1025.57, 1, 0, 0, 100, 'Sum1', 0, 6, 343.98, 305.14, 999.14, 0),
(1422, 2807.43, -1165.53, 1025.57, 1, 0, 0, 10000, 'Sum1', 0, 6, 343.98, 305.14, 999.14, 0),
(1423, 2807.43, -1165.53, 1025.57, 1, 0, 0, 10000, 'Sum', 0, 6, 343.98, 305.14, 999.14, 0),
(1424, 2807.43, -1165.53, 1025.57, 1, 0, 0, 1000, 'Sum', 0, 6, 343.98, 305.14, 999.14, 0),
(1425, 2807.43, -1165.53, 1025.57, 1, 0, 0, 1000, 'Sum', 0, 2, 266.56, 305.02, 999.14, 0),
(1429, 878.322, -725.685, 106.448, 1, 3717, 0, 600000, 'HÃ¡z', 0, 2, 446.97, 1397.22, 1084.3, 0),
(1841, 1029.63, -811.762, 101.852, 4, 560, 0, 0, 'Jack', 0, 1, 1412.14, -2.28, 1000.92, 0),
(1438, 2491.36, -1012.29, 65.3984, 1, 2434, 0, 70000, 'HÃ¡z.', 0, 9, 260.67, 1237.32, 1084.25, 0),
(1440, 1976.2, -1633.91, 16.2111, 1, 4486, 0, 80000, 'HÃ¡z.', 0, 9, 260.67, 1237.32, 1084.25, 0),
(1475, 1685.3, -1463.94, 13.5469, 1, 3090, 0, 1, 'HÃ¡z', 0, 7, 225.71, 1021.44, 1084.01, 0),
(1448, 1702.63, -1472.35, 13.5469, 4, 2533, 0, 200000, 'GarÃ¡zs.', 0, 1, 1412.14, -2.28, 1000.92, 0),
(1474, 1692.45, -1458.4, 13.5469, 1, 2533, 0, 1, 'HÃ¡z', 0, 7, 225.71, 1021.44, 1084.01, 0),
(1820, 1204.78, 12.542, 1000.92, 1, 0, 0, 0, 'Iroda', 65, 3, 1494.28, 1303.91, 1093.28, 0),
(1461, 2256.79, -1407.62, 24, 3, 0, 0, 0, '52', 0, 9, 260.67, 1237.32, 1084.25, 0),
(1462, 1566.42, 23.292, 24.1641, 1, 1886, 0, 1, 'Kocsma', 0, 11, 501.84, -67.84, 998.75, 0),
(1464, 1546.83, 32.4521, 24.1406, 1, 1886, 0, 1, 'HÃ¡z', 0, 5, 318.55, 1114.47, 1083.88, 0),
(1465, 927.45, -928.15, 42.6016, 4, 2569, 0, 0, 'LCN', 0, 1, 1412.14, -2.28, 1000.92, 0),
(1878, 745.094, -556.617, 18.0129, 1, 5362, 0, 0, 'Amanda', 0, 8, 2365.14, -1135.35, 1050.87, 0),
(1656, 1210.79, 4.19824, 1000.92, 1, 0, 0, 0, 'VIP', 1, 1, 2218.24, -1076.27, 1050.48, 0),
(1657, 1210.79, 4.19824, 1000.92, 1, 0, 0, 0, 'VIP', 1, 1, 2218.24, -1076.27, 1050.48, 0),
(1637, -2164.71, -2479.8, 31.8163, 1, 705, 0, 170000, 'HÃ¡z', 0, 2, 446.97, 1397.22, 1084.3, 0),
(1839, 954.205, -909.861, 45.7656, 3, 0, 0, 0, 'Russian', 0, 18, 1726.86, -1638.05, 20.22, 0),
(1853, 1204.53, 12.665, 1000.92, 1, 0, 0, 1, 'Iroda', 65, 3, 965.16, -53.4082, 1001.12, 0),
(1479, 1361.66, -1659.23, 13.3828, 4, 2718, 0, 1, 'GarÃ¡zs', 0, 1, 1412.14, -2.28, 1000.92, 0),
(1483, 767.56, -1655.82, 5.60938, 1, 3477, 0, 1, 'HÃ¡z', 0, 5, 22.98, 1403.6, 1084.42, 0),
(1484, 765.628, -1660.17, 4.49172, 4, 3477, 0, 30000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(1485, 2457.11, -1102.5, 43.8672, 1, 3451, 0, 80000, 'HÃ¡z', 0, 2, 446.97, 1397.22, 1084.3, 0),
(1486, 700.293, -1060.28, 49.4217, 1, 3676, 0, 1000000, 'HÃ¡z.', 0, 6, 234.2, 1063.85, 1084.21, 0),
(1858, 2845.54, -1287.24, 19.1749, 4, 4237, 0, 100000, 'GarÃ¡zs', 0, 1, 1412.14, -2.28, 1000.92, 0),
(1491, -381.82, -1426.79, 26.0285, 4, 1605, 0, 1, 'GarÃ¡zs', 0, 1, 1412.14, -2.28, 1000.92, 0),
(1492, -382.643, -1439.2, 26.0655, 1, 1605, 0, 1, 'HÃ¡z', 0, 15, 295.05, 1472.36, 1080.25, 0),
(1495, 2333.52, -1908.12, 13.0557, 4, 173, 0, 1, 'GarÃ¡zs', 0, 1, 1412.14, -2.28, 1000.92, 0),
(1499, 317.277, -88.0928, 2.4602, 4, 1980, 0, 1, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(1500, 317.975, -83.8643, 2.34703, 4, 4144, 0, 1, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(1501, 313.598, -92.4707, 3.53539, 1, 1980, 0, 1, 'HÃ¡z', 0, 10, 2259.68, -1136.09, 1050.63, 0),
(1905, -516.133, -540.091, 25.5234, 2, 2939, 0, 0, 'Paintball', 1, 10, -1128.64, 1066.33, 1345.74, 0),
(1903, 219.333, -1249.95, 78.3356, 1, 705, 0, 1500000, 'HaakemHÃ¡z', 0, 6, 234.2, 1063.85, 1084.21, 0),
(1900, 1204.84, 12.6631, 1000.92, 1, 0, 0, 0, 'PrivÃ¡t', 0, 3, 975.26, -8.64, 1001.14, 0),
(1833, 810.887, -1616.15, 13.5469, 2, 1863, 0, 0, 'BurgerShot', 0, 10, 362.88, -75.11, 1001.5, 0),
(1899, 2267.85, -1671.17, 15.3594, 3, 0, 0, 0, 'Tatto-Shop', 58, 17, -204.23, -8.88, 1002.27, 0),
(1840, 1726.95, -1636.71, 20.2241, 3, 0, 0, 0, 'Apartman_Complex', 0, 1, 2266.32, 1647.59, 1084.23, 0),
(1872, 2234.65, -1127.7, 25.7969, 4, 1475, 0, 0, 'GarÃ¡zs', 65, 1, 1412.14, -2.28, 1000.92, 0),
(1526, 1396.99, -1569.72, 14.2667, 3, 0, 0, 1, 'Ã‰tterem', 0, 1, -794.98, 489.78, 1376.2, 0),
(1787, 2348.53, -1372.78, 24.3984, 3, 0, 0, 0, 'The', 0, 18, -229.17, 1401.14, 27.76, 0),
(1558, -2134.68, -2504.35, 31.8163, 1, 2099, 0, 1, 'HÃ¡z', 0, 6, 234.2, 1063.85, 1084.21, 0),
(1547, 912.555, -1002.99, 38.0122, 1, 3161, 0, 1, 'Ã³rrÃ¡skamat', 0, 12, 2324.42, -1149.2, 1050.71, 0),
(1550, 2172.55, -1615.4, 14.2763, 3, 0, 0, 1, 'HÃ¡z', 0, 5, 318.55, 1114.47, 1083.88, 0),
(1551, 2185.34, -1608.07, 14.3594, 3, 0, 0, 1, 'HÃ¡z', 0, 6, 2333, -1077, 1049, 0),
(1552, 248.12, -85.5068, 2.42772, 4, 4476, 0, 1, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(1553, 247.783, -87.959, 2.37312, 4, 1044, 0, 1, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(1554, 252.652, -92.5234, 3.53539, 1, 4476, 0, 1, 'GarÃ¡zs', 0, 6, 2196.85, -1204.4, 1049, 0),
(1556, 299.02, -1338.39, 53.4416, 1, 1351, 0, 1, 'BroadwayFamily', 0, 6, 234.2, 1063.85, 1084.21, 0),
(1559, -2180.74, -2529.06, 31.8163, 1, 554, 0, 1, 'HÃ¡z', 0, 6, 234.2, 1063.85, 1084.21, 0),
(1566, 246.683, -128.965, 2.19252, 4, 1886, 0, 1, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(1565, 246.642, -125.741, 2.18586, 4, 1886, 0, 1, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(1567, 295.185, -55.3096, 2.77721, 1, 554, 0, 1, 'HÃ¡z', 0, 15, 295.05, 1472.36, 1080.25, 0),
(1572, 2485.61, -1958.75, 13.581, 2, 619, 0, 1, 'AutÃ³ker', 0, 3, 1494.28, 1303.91, 1093.28, 0),
(1574, 2333.33, -1918.27, 13.0912, 4, 3294, 0, 1, 'GarÃ¡zs', 0, 2, 613.655, -74.5078, 997.992, 0),
(1575, 2333.36, -1943.23, 14.9688, 1, 3294, 0, 1, 'HÃ¡z', 0, 12, 2324.42, -1149.2, 1050.71, 0),
(1580, 2448.48, -11.0195, 27.6835, 1, 3013, 0, 1, 'HÃ¡z', 0, 5, 226.56, 1114.19, 1080.99, 0),
(1584, 2557.01, 87.915, 27.6756, 1, 2439, 0, 1, 'hÃ¡z', 0, 6, 234.2, 1063.85, 1084.21, 0),
(1586, 2510.14, 89.0713, 27.6835, 1, 968, 0, 170000, 'HÃ¡z', 0, 9, 2317.81, -1026.55, 1050.21, 0),
(1588, 2519.34, 58.3525, 27.6835, 1, 4171, 0, 170000, 'HÃ¡z', 0, 9, 2317.81, -1026.55, 1050.21, 0),
(1593, -1068.7, -1205.53, 129.477, 1, 979, 0, 120000, 'HÃ¡z', 0, 10, 422.26, 2536.37, 10, 0),
(1592, -1060.16, -1205.5, 129.219, 1, 3348, 0, 120000, 'HÃ¡z', 0, 8, 2807.66, -1174.54, 1025.57, 0),
(1594, 2689.05, -2452.21, 13.6375, 4, 4613, 0, 200000, 'Tigrisek_Helye', 0, 1, 1412.14, -2.28, 1000.92, 0),
(1595, 819.982, -607.504, 16.3359, 4, 4084, 0, 200000, 'GarÃ¡zs', 0, 1, 1412.14, -2.28, 1000.92, 0),
(1597, -271.843, -2216.29, 28.3741, 4, 2372, 0, 0, 'Hells', 0, 1, 1412.14, -2.28, 1000.92, 0),
(1598, 2193.6, -1107.01, 25.005, 4, 805, 0, 250000, 'GarÃ¡zs', 0, 1, 1412.14, -2.28, 1000.92, 0),
(1811, 661.254, -573.472, 16.3359, 3, 0, 0, 0, 'Quickstore', 0, 10, 6.05, -31.27, 1003.54, 0),
(1601, 2185.1, -1365.49, 25.8293, 1, 575, 0, 150000, 'HÃ¡z', 0, 9, 260.67, 1237.32, 1084.25, 0),
(1904, 226.297, -1245.46, 78.2997, 4, 705, 0, 500000, 'HaakemGarÃ¡zs', 0, 1, 1412.14, -2.28, 1000.92, 0),
(1602, 2269.23, -1883.04, 14.2344, 1, 4290, 0, 120000, 'HÃ¡z', 0, 9, 260.67, 1237.32, 1084.25, 0),
(1603, 2480.95, 64.459, 27.6835, 1, 4085, 0, 0, 'Palominoi', 220000, 9, 2317.81, -1026.55, 1050.21, 0),
(1852, 1205.04, 12.6641, 1000.92, 1, 0, 0, 0, 'Iroda', 65, 3, 975.26, -8.64, 1001.14, 0),
(1606, 207.781, -62.0107, 1.89861, 1, 918, 0, 0, 'Bianchi\'s', 500000, 3, 965.16, -53.4082, 1001.12, 0),
(1837, 1928.5, -1915.9, 15.2568, 1, 2197, 0, 1, 'LakÃ¡s', 0, 5, 22.98, 1403.6, 1084.42, 0),
(1689, 855.136, -1527.95, 13.36, 4, 324, 0, 0, 'GarÃ¡zs', 0, 1, 1412.14, -2.28, 1000.92, 0),
(1619, 842.82, -760.762, 84.9715, 4, 4747, 0, 200000, 'GarÃ¡zs', 0, 1, 1412.14, -2.28, 1000.92, 0),
(1620, 848.57, -744.97, 94.9693, 1, 4747, 0, 500000, 'HÃ¡z', 0, 9, 2317.81, -1026.55, 1050.21, 0),
(1632, -2179.22, -2476.17, 30.6172, 4, 705, 0, 200000, 'GarÃ¡zs', 0, 1, 1412.14, -2.28, 1000.92, 0),
(1848, 1602.61, -1837.42, 13.4982, 4, 832, 0, 1000, 'GarÃ¡zs', 0, 1, 1412.14, -2.28, 1000.92, 0),
(1893, 1353.01, -624.375, 109.133, 4, 3306, 0, 0, 'GarÃ¡zs', 0, 1, 1412.14, -2.28, 1000.92, 0),
(1651, -2154.02, -2460.87, 30.8516, 3, 0, 0, 0, 'Angel', 0, 17, 377.16, -192.91, 1000.64, 0),
(1650, 1208.31, -4.27832, 1001.84, 4, 0, 0, 20000, 'GarÃ¡zs', 0, 1, 1412.14, -2.28, 1000.92, 0),
(1649, 1211.27, 3.68262, 1000.92, 4, 0, 0, 20000, 'GarÃ¡zs', 0, 1, 1412.14, -2.28, 1000.92, 0),
(1648, 1210.75, 5.66406, 1000.92, 4, 0, 0, 20000, 'GarÃ¡zs', 0, 1, 1412.14, -2.28, 1000.92, 0),
(1647, -2173.93, -2481.78, 31.8163, 1, 705, 0, 1, 'HÃ¡z', 0, 6, 744.46, 1436.68, 1102.7, 0),
(1660, 2433.48, 2476.06, 69.4657, 3, 0, 0, 0, 'VIP', 1, 1, 2218.24, -1076.27, 1050.48, 0),
(1678, 2115.63, -1888.97, 13.5469, 4, 1433, 0, 80000, 'GarÃ¡zs', 0, 2, 613.655, -74.5078, 997.992, 0),
(1677, 2165.65, -1888.56, 13.5469, 4, 0, 0, 80000, 'GarÃ¡zs', 0, 2, 613.655, -74.5078, 997.992, 0),
(1728, 2190.69, -46.5928, 27.4766, 4, 3153, 0, 0, 'GarÃ¡zs', 0, 18, 1292.28, 0.033525, 1001.02, 0),
(1671, 910.094, -817.141, 103.126, 1, 5170, 0, 600000, 'HÃ¡z', 0, 9, 83, 1322.48, 1083.86, 0),
(1668, 915.681, -834.017, 93.2835, 4, 5170, 0, 100000, 'GarÃ¡zs', 0, 2, 613.655, -74.5078, 997.992, 0),
(1680, 2095.47, -1889.14, 13.5469, 4, 1605, 0, 80000, 'GarÃ¡zs', 0, 2, 613.655, -74.5078, 997.992, 0),
(1682, -14.416, -276.73, 5.42969, 4, 2613, 0, 250000, 'Nagy_GarÃ¡zs', 0, 1, 1412.14, -2.28, 1000.92, 0),
(1685, 166.646, -54.8438, 1.57812, 4, 0, 0, 250000, 'Nagy_GarÃ¡zs', 0, 1, 1412.14, -2.28, 1000.92, 0),
(1686, 166.47, -44.793, 1.57812, 4, 0, 0, 250000, 'Nagy_GarÃ¡zs', 0, 1, 1412.14, -2.28, 1000.92, 0),
(1687, 166.841, -14.7334, 1.57812, 4, 0, 0, 250000, 'Nagy_GarÃ¡zs', 0, 1, 1412.14, -2.28, 1000.92, 0),
(1695, 2558.51, -1192.64, 61.6053, 4, 3724, 0, 200000, 'GarÃ¡zs', 0, 1, 1412.14, -2.28, 1000.92, 0),
(1696, 2550.19, -1196.89, 60.8011, 1, 3724, 0, 170000, 'HÃ¡z', 0, 6, 234.2, 1063.85, 1084.21, 0),
(1713, 2482.41, -1536.73, 24.0818, 1, 979, 0, 1, 'HÃ¡z', 0, 3, 965.16, -53.4082, 1001.12, 0),
(1714, 1321.18, -1082.4, 25.5962, 1, 5237, 0, 500000, 'HÃ¡z', 0, 10, 2259.68, -1136.09, 1050.63, 0),
(1716, 1330.47, -1058.98, 28.6111, 4, 1044, 0, 200000, 'GarÃ¡zs', 0, 1, 1412.14, -2.28, 1000.92, 0),
(1718, 1326.95, -1066.54, 31.5547, 1, 1044, 0, 500000, 'HÃ¡z', 0, 5, 226.56, 1114.19, 1080.99, 0),
(1719, 1326.76, -1091.93, 27.9766, 1, 1043, 0, 500000, 'HÃ¡z', 0, 3, 235.44, 1186.83, 1080.25, 0),
(1720, 1330.12, -1099.24, 24.9077, 4, 1043, 0, 200000, 'GarÃ¡zs', 0, 1, 1412.14, -2.28, 1000.92, 0),
(1724, 1254.55, -804.096, 84.1406, 4, 1153, 0, 1, 'GarÃ¡zs', 0, 18, 1292.28, 0.033525, 1001.02, 0),
(1725, 1142.12, -1092.84, 28.1875, 1, 3600, 0, 220000, 'HÃ¡z', 0, 12, 2324.42, -1149.2, 1050.71, 0),
(1727, 1144.17, -1100.96, 25.8159, 4, 3600, 0, 90000, 'GarÃ¡zs', 0, 3, 612.769, -124.025, 997.992, 0),
(1729, 2201.08, -37.4502, 28.1535, 1, 3153, 0, 0, 'HÃ¡z', 0, 8, 2365.14, -1135.35, 1050.87, 0),
(1730, 1981.22, -1719.01, 17.0304, 1, 3153, 0, 300000, 'HÃ¡z', 0, 9, 83, 1322.48, 1083.86, 0),
(1731, 694.387, -1645.8, 4.09375, 1, 578, 0, 298000, 'HÃ¡z', 0, 2, 2237.52, -1081.64, 1049.02, 0),
(1732, 561.963, -1113.67, 62.8064, 1, 3153, 0, 800000, 'NagyHÃ¡z', 0, 3, 235.44, 1186.83, 1080.25, 0),
(1734, 2852.55, -1330.58, 11.0706, 4, 3571, 0, 100000, 'GarÃ¡zs1', 0, 18, 1292.28, 0.033525, 1001.02, 0),
(1735, 2852.35, -1325.83, 11.0655, 4, 3571, 0, 100000, 'GarÃ¡zs2', 0, 18, 1292.28, 0.033525, 1001.02, 0),
(1736, 2854.49, -1342.64, 11.0625, 4, 329, 0, 100000, 'GarÃ¡zs2', 0, 18, 1292.28, 0.033525, 1001.02, 0),
(1737, 2855.72, -1354.66, 11.0663, 4, 329, 0, 100000, 'GarÃ¡zs1', 0, 18, 1292.28, 0.033525, 1001.02, 0),
(1738, 2842.12, -1335.47, 14.7421, 1, 3571, 0, 120000, 'HÃ¡z', 0, 12, 2324.42, -1149.2, 1050.71, 0),
(1739, 2853.11, -1366.19, 14.1641, 1, 329, 0, 120000, 'HÃ¡z', 0, 12, 2324.42, -1149.2, 1050.71, 0),
(1740, 2866.58, -1988.84, 11.1016, 3, 0, 0, 0, 'Forgalmi', 0, 3, 1494.28, 1303.91, 1093.28, 0),
(1773, 2453.02, -1759.46, 13.5907, 1, 5226, 0, 0, 'Cuban', 62, 10, 422.26, 2536.37, 10, 0),
(1902, 2226.53, -2682.18, 13.5409, 4, 705, 0, 0, 'GarÃ¡zs', 0, 1, 1412.14, -2.28, 1000.92, 0),
(1786, 2444.25, 92.2422, 28.4416, 1, 5100, 0, 0, 'Fernando', 0, 7, 225.71, 1021.44, 1084.01, 0),
(1795, 2397.81, -1899.08, 13.5469, 3, 0, 0, 0, 'Cluck\'n\'Bell', 0, 17, 377.16, -192.91, 1000.64, 0),
(1796, 1352.34, -1759.06, 13.5078, 3, 0, 0, 0, '27/7', 0, 17, -25.91, -188.05, 1003.54, 0),
(1800, 928.705, -1352.91, 13.3438, 3, 0, 0, 0, 'Cluck\'n\'Bell', 0, 17, 377.16, -192.91, 1000.64, 0),
(1802, -78.4893, -1169.85, 2.13854, 3, 0, 0, 0, 'Twenty-Four', 0, 18, -31.02, -91.92, 1003.54, 0),
(1803, 1199.24, -918.354, 43.1217, 3, 0, 0, 0, 'Burger', 0, 9, 364.95, -11.6, 1001.85, 0),
(1809, 2112.83, -1211.58, 23.963, 3, 0, 0, 0, 'Suburban', 0, 1, 203.79, -50.34, 1001.8, 0),
(1885, 2129.98, -1761.62, 13.5625, 2, 5089, 0, 0, 'SIX_PUB', 58, 6, 744.46, 1436.68, 1102.7, 0),
(1907, 1715.07, -2125.15, 14.0566, 1, 4, 0, 0, 'Bence', 0, 7, 225.71, 1021.44, 1084.01, 0);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `jarmuvek`
--

CREATE TABLE `jarmuvek` (
  `id` int(11) NOT NULL,
  `hp` int(3) NOT NULL DEFAULT 1000,
  `x` varchar(255) NOT NULL,
  `rot` varchar(255) NOT NULL,
  `y` varchar(255) NOT NULL,
  `z` varchar(255) NOT NULL,
  `model` int(11) NOT NULL,
  `interior` int(11) NOT NULL DEFAULT 0,
  `dimension` int(11) NOT NULL DEFAULT 0,
  `parkedPosition` varchar(1000) NOT NULL,
  `akkumulator` int(11) NOT NULL DEFAULT 100,
  `uzemanyag` int(11) NOT NULL DEFAULT 100,
  `lampa` int(11) NOT NULL DEFAULT 0,
  `locked` int(11) NOT NULL DEFAULT 1,
  `motorStatusz` int(11) NOT NULL DEFAULT 0,
  `tulajdonos` int(11) NOT NULL,
  `jarmuSzine` varchar(255) NOT NULL DEFAULT '[ [ 0 , 0 , 0 , 0 , 0 , 0 ] ]',
  `neonID` varchar(255) NOT NULL DEFAULT 'false',
  `stickerID` varchar(255) NOT NULL DEFAULT 'false',
  `jarmuTuningok` varchar(255) NOT NULL DEFAULT '[ [ 1, 1, 1, 1, 1, 1 ] ]',
  `lampaSzine` varchar(255) NOT NULL DEFAULT '[ [ 255, 255, 255 ] ]',
  `rearWheel` varchar(255) NOT NULL DEFAULT 'default',
  `frontWheel` varchar(255) NOT NULL DEFAULT 'default',
  `jarmuOptikaiTuningok` varchar(255) NOT NULL DEFAULT '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]',
  `jarmuToresek` varchar(300) NOT NULL DEFAULT '[ [ 0, 1, 2, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]',
  `frakcio` int(11) NOT NULL DEFAULT 0,
  `alvazSzam` varchar(22) NOT NULL DEFAULT 'Nincs',
  `motorSzam` varchar(22) NOT NULL DEFAULT 'Nincs',
  `rendszam` varchar(255) NOT NULL,
  `ablak` int(1) NOT NULL DEFAULT 0,
  `km` int(50) NOT NULL DEFAULT 0,
  `driveType` varchar(20) NOT NULL DEFAULT 'false',
  `lsdDoor` int(1) NOT NULL DEFAULT 0,
  `steeringLock` int(3) NOT NULL DEFAULT 0,
  `variant` int(1) NOT NULL DEFAULT 0,
  `airRide` varchar(30) NOT NULL DEFAULT 'false'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- A tábla adatainak kiíratása `jarmuvek`
--

INSERT INTO `jarmuvek` (`id`, `hp`, `x`, `rot`, `y`, `z`, `model`, `interior`, `dimension`, `parkedPosition`, `akkumulator`, `uzemanyag`, `lampa`, `locked`, `motorStatusz`, `tulajdonos`, `jarmuSzine`, `neonID`, `stickerID`, `jarmuTuningok`, `lampaSzine`, `rearWheel`, `frontWheel`, `jarmuOptikaiTuningok`, `jarmuToresek`, `frakcio`, `alvazSzam`, `motorSzam`, `rendszam`, `ablak`, `km`, `driveType`, `lsdDoor`, `steeringLock`, `variant`, `airRide`) VALUES
(4, 1000, '2162.021729', '[ [ 0, 0, 94 ] ]', '-1177.713623', '23.816740', 534, 0, 0, '', 100, 100, 0, 1, 0, 8, '[ [ 128, 28, 67, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', 'false', 'false', '[ [ 1, 1, 1, 1, 1, 1 ] ]', '[ [ 255, 255, 255 ] ]', 'default', 'default', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 1, 2, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', 0, 'Nincs', 'Nincs', 'S-23LA5M', 0, 0, 'false', 0, 0, 0, 'false'),
(6, 1000, '2486.455078', '[ [ ] ]', '-1506.908203', '23.828125', 596, 0, 0, '', 100, 100, 0, 1, 0, 8, '[ [ 255, 255, 255, 0, 0, 0 ] ]', 'false', 'false', '[ [ 1, 1, 1, 1, 1, 1 ] ]', '[ [ 255, 255, 255 ] ]', 'default', 'default', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 1, 2, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', 53, 'Nincs', 'Nincs', 'S-I2499C', 0, 0, 'false', 0, 0, 0, 'false');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `jogsik`
--

CREATE TABLE `jogsik` (
  `id` int(11) NOT NULL,
  `adatok` varchar(1000) NOT NULL DEFAULT '[[ false ]]',
  `date` date NOT NULL,
  `exdate` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `kapuk`
--

CREATE TABLE `kapuk` (
  `id` int(11) NOT NULL,
  `open` varchar(1000) NOT NULL,
  `close` varchar(1000) NOT NULL,
  `model` int(11) NOT NULL,
  `interior` int(11) NOT NULL DEFAULT 0,
  `dimension` int(11) NOT NULL DEFAULT 0,
  `time` int(11) NOT NULL DEFAULT 5
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- A tábla adatainak kiíratása `kapuk`
--

INSERT INTO `kapuk` (`id`, `open`, `close`, `model`, `interior`, `dimension`, `time`) VALUES
(1, '[ [ 1961.793, -2189.8394, 9.566783900000001, 0, 0, 180.34894 ] ]', '[ [ 1961.793, -2189.8394, 13.546875, 0, 0, 180.34894 ] ]', 980, 0, 0, 4),
(2, '[ [ 1588.3077, -1638.0686, 9.3927212, 0, 0, 179.30377 ] ]', '[ [ 1588.3077, -1638.0686, 15.122852, 0, 0, 179.30377 ] ]', 980, 0, 0, 4),
(10, '[ [ 1544.6956, -1630.8501, 13.152807, 0, 359.50012, 89.954926 ] ]', '[ [ 1544.6956, -1630.8501, 13.152807, 0, 90.30542, 89.954926 ] ]', 968, 0, 0, 4),
(36, '[ [ 2522.0044, -1273.1726, 34.886925, 0, 0, 270.01013 ] ]', '[ [ 2522.0044, -1273.1726, 34.886925, 0, 0, 270.01013 ] ]', 980, 0, 0, 4),
(45, '[ [ 829.06012, -867.55804, 64.582184, 0, 0, 20.612366 ] ]', '[ [ 829.06012, -867.55804, 67.962906, 0, 0, 20.612366 ] ]', 969, 0, 0, 4),
(46, '[ [ 1245.7526, -767.0979, 88.144295, 0, 0, 180.25757 ] ]', '[ [ 1245.7526, -767.0979, 92.285179, 0, 0, 180.25757 ] ]', 980, 0, 0, 4),
(47, '[ [ 1357.7296, -842.28094, 42.495972, 0, 0, 78.493286 ] ]', '[ [ 1357.7296, -842.28094, 46.585285, 0, 0, 78.493286 ] ]', 980, 0, 0, 4),
(58, '[ [ 402.69604, -1257.114, 48.116756, 0, 0.19992065, 24.601349 ] ]', '[ [ 402.69604, -1257.114, 52.14608, 0, 0.19992065, 24.601349 ] ]', 980, 0, 0, 4),
(63, '[ [ 1003.0023, -643.83905, 117.58118, 0, 0, 28.321686 ] ]', '[ [ 1003.0023, -643.83905, 121.58204, 0, 0, 28.321686 ] ]', 980, 0, 0, 4),
(64, '[ [ -1421.1997, 937.6666300000001, 1035.9437, 0, 353.09949, 358.51221 ] ]', '[ [ -1421.1997, 937.6666300000001, 1035.9437, 0, 273.89453, 358.51221 ] ]', 968, 15, 1166, 4),
(92, '[ [ 263.66068, -1333.6597, 49.29768, 0, 0, 35.527649 ] ]', '[ [ 263.66068, -1333.6597, 53.267014, 0, 0, 35.527649 ] ]', 980, 0, 0, 4),
(106, '[ [ 2137.3794, -1374.2766, 20.228043, 0, 0, 359.39343 ] ]', '[ [ 2137.3794, -1374.2766, 22.988106, 0, 0, 359.39343 ] ]', 980, 0, 0, 4),
(112, '[ [ 1579.1268, -1274.3877, 13.754915, 0, 0, 180.50317 ] ]', '[ [ 1579.1268, -1274.3877, 15.054945, 0, 0, 180.50317 ] ]', 980, 0, 0, 4),
(113, '[ [ 1567.5662, -1274.4342, 13.636391, 0, 0, 180.14984 ] ]', '[ [ 1567.5662, -1274.4342, 15.066423, 0, 0, 180.14984 ] ]', 980, 0, 0, 4),
(114, '[ [ 961.1815800000001, -942.0766599999999, 36.21801, 0, 0, 0.11645508 ] ]', '[ [ 961.1815800000001, -942.0766599999999, 39.967381, 0, 0, 0.11645508 ] ]', 980, 0, 0, 4),
(124, '[ [ 197.68384, -1389.5305, 44.164589, 0, 353.99963, 46.255951 ] ]', '[ [ 197.68384, -1389.5305, 47.294064, 0, 353.99963, 46.255951 ] ]', 969, 0, 0, 4),
(126, '[ [ 1702.3944, -2126.4724, 12.486851, 0, 0, 180.40594 ] ]', '[ [ 1707.3993, -2126.4724, 12.486851, 0, 0, 180.40594 ] ]', 969, 0, 0, 4),
(127, '[ [ 2122.4636, -2123.9646, 9.786788899999999, 0, 0, 168.01575 ] ]', '[ [ 2122.4636, -2123.9646, 12.786858, 0, 0, 168.01575 ] ]', 980, 0, 0, 4),
(128, '[ [ 2003.7192, -1383.5316, 993.01489, 0, 0, 0.8812561 ] ]', '[ [ 2003.7192, -1383.5316, 996.05786, 0, 0, 0.8812561 ] ]', 969, 0, 16, 4),
(129, '[ [ 2001.8524, -1394.149, 993.00488, 0, 0, 90.459473 ] ]', '[ [ 2001.8524, -1394.149, 995.7876, 0, 0, 90.459473 ] ]', 969, 0, 16, 4),
(133, '[ [ 757.01172, -1384.9967, 9.961384799999999, 0, 0, 359.57019 ] ]', '[ [ 757.01172, -1384.9967, 15.291507, 0, 0, 359.57019 ] ]', 980, 0, 0, 4),
(134, '[ [ 956.8385, -635.22498, 116.40687, 0, 0, 200.53845 ] ]', '[ [ 956.8385, -635.22498, 121.708, 0, 0, 200.53845 ] ]', 980, 0, 0, 4);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `kukak`
--

CREATE TABLE `kukak` (
  `dbid` int(11) NOT NULL,
  `pos` varchar(1000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- A tábla adatainak kiíratása `kukak`
--

INSERT INTO `kukak` (`dbid`, `pos`) VALUES
(1, '[ [ 1928.744140625, -1767.5380859375, 12.9828125, 0, 0 ] ]'),
(4, '[ [ 1000.3037109375, -930.189453125, 41.78689727783203, 0, 0 ] ]'),
(5, '[ [ 2130.2412109375, -1151.318359375, 23.6428466796875, 0, 0 ] ]'),
(6, '[ [ 1172.080078125, -1328.1533203125, 15.01034412384033, 0, 0 ] ]'),
(7, '[ [ 1553.8251953125, -1666.49609375, 13.15581951141357, 0, 0 ] ]'),
(8, '[ [ 1420.64453125, -1672.89453125, 13.146875, 0, 0 ] ]'),
(9, '[ [ -78.7392578125, -1170.7548828125, 1.734313583374024, 0, 0 ] ]'),
(11, '[ [ 2167.9580078125, -2159.6484375, 13.146875, 0, 0 ] ]'),
(13, '[ [ 1474.5810546875, -1763.8671875, 13.146875, 0, 0 ] ]'),
(15, '[ [ -2420.1533203125, 973.4384765625, 44.896875, 0, 0 ] ]'),
(17, '[ [ 1367.0849609375, -1282.9873046875, 13.146875, 0, 0 ] ]'),
(21, '[ [ 1212.9306640625, -1814.12890625, 16.19375, 0, 0 ] ]'),
(22, '[ [ 1673.3330078125, -1889.3056640625, 13.146875, 0, 0 ] ]'),
(23, '[ [ 2718.271484375, -2417.546875, 13.22873268127441, 0, 0 ] ]'),
(24, '[ [ 2021.4423828125, -1402.0703125, 16.77356109619141, 0, 0 ] ]'),
(25, '[ [ 689.1220703125, -1251.1904296875, 13.22362670898437, 0, 0 ] ]'),
(26, '[ [ 257.5849609375, 79.9775390625, 1003.240625, 6, 16 ] ]'),
(27, '[ [ 1133.2216796875, -1293.7626953125, 13.15587005615234, 0, 0 ] ]'),
(28, '[ [ 2069.9033203125, -1706.3125, 13.146875, 0, 0 ] ]'),
(29, '[ [ 1955.900390625, -1822.03515625, 13.146875, 0, 0 ] ]'),
(32, '[ [ 240.6357421875, 77.736328125, 1004.6390625, 6, 16 ] ]'),
(33, '[ [ 2187.9619140625, -980.5056762695312, 44.1859375, 0, 0 ] ]'),
(34, '[ [ -1551.5322265625, -912.197265625, 183.3925720214844, 0, 0 ] ]'),
(35, '[ [ -678.5009765625, -1982.625, 24.21324501037598, 0, 0 ] ]'),
(36, '[ [ 2649.171875, -2012.6220703125, 13.1546875, 0, 0 ] ]'),
(37, '[ [ 221.3818359375, 181.744140625, 1002.63125, 3, 17 ] ]'),
(38, '[ [ 301.0673828125, -1335.759765625, 53.04235992431641, 0, 0 ] ]'),
(39, '[ [ 256.603515625, -1372.4521484375, 52.709375, 0, 0 ] ]'),
(41, '[ [ 2486.5947265625, 127.916015625, 26.5765625, 0, 0 ] ]'),
(42, '[ [ 251.390625, 70.94921875, 1003.240625, 6, 16 ] ]'),
(43, '[ [ 2139.3466796875, -1157.4384765625, 23.5921875, 0, 0 ] ]'),
(44, '[ [ 82.5341796875, 1334.4990234375, 1083.4671875, 9, 289 ] ]'),
(45, '[ [ 1273.3037109375, -1722.05078125, 13.146875, 0, 0 ] ]'),
(46, '[ [ 218.78125, 66.1494140625, 1004.646630859375, 6, 16 ] ]'),
(47, '[ [ 1577.044921875, -1690.4765625, 5.81875, 0, 0 ] ]'),
(49, '[ [ 1292.1103515625, -6.5888671875, 1000.624047851563, 18, 597 ] ]'),
(50, '[ [ 689.640625, -470.6630859375, 16.13629684448242, 0, 0 ] ]'),
(52, '[ [ 834.720703125, -1070.03515625, 24.72286376953125, 0, 0 ] ]'),
(54, '[ [ 1257.443359375, -810.34375, 83.74062499999999, 0, 0 ] ]'),
(56, '[ [ 1308.33203125, -0.7080078125, 1000.62978515625, 18, 649 ] ]'),
(57, '[ [ -2026.6201171875, -119.38671875, 1034.771875, 3, 543 ] ]'),
(58, '[ [ 2167.763671875, -973.8681640625, 44.1859375, 0, 0 ] ]'),
(59, '[ [ 2474.259765625, -1045.556640625, 64.85080871582031, 0, 0 ] ]'),
(60, '[ [ 2606.333984375, -1039.291015625, 69.17812499999999, 0, 0 ] ]'),
(61, '[ [ 2547.4453125, -1077.0009765625, 65.78855285644531, 0, 0 ] ]'),
(62, '[ [ 2538.4013671875, -1037.61328125, 69.17812499999999, 0, 0 ] ]'),
(63, '[ [ 2533.46875, -1058.2841796875, 69.17047271728515, 0, 0 ] ]'),
(64, '[ [ 2202.1376953125, -1494.40234375, 25.1390625, 0, 0 ] ]'),
(65, '[ [ 757.90234375, -501.798828125, 16.9359375, 0, 0 ] ]'),
(66, '[ [ -282.5341796875, -2171.3369140625, 28.23169288635254, 0, 0 ] ]'),
(67, '[ [ 251.259765625, 64.96484375, 1003.240625, 6, 16 ] ]'),
(68, '[ [ 722.5703125, -999.5439453125, 52.28328857421875, 0, 0 ] ]'),
(69, '[ [ 2768.1162109375, -1619.40625, 10.52715549468994, 0, 0 ] ]'),
(70, '[ [ 2030.5478515625, -1110.1201171875, 25.70700988769531, 0, 0 ] ]'),
(71, '[ [ 244.28515625, 1022.5908203125, 1083.610375976562, 7, 721 ] ]'),
(72, '[ [ -1580.884765625, 687.3037109375, 6.7875, 0, 0 ] ]'),
(73, '[ [ 236.431640625, 64.9697265625, 1004.6390625, 6, 16 ] ]'),
(74, '[ [ 2133.705078125, -1374.88671875, 23.584375, 0, 0 ] ]'),
(75, '[ [ 2249.26171875, -1187.35546875, 1029.404321289062, 15, 481 ] ]'),
(79, '[ [ -2232.28515625, 2350.6845703125, 4.58709487915039, 0, 0 ] ]'),
(80, '[ [ 305.220703125, -1156.1962890625, 80.51406249999999, 0, 0 ] ]'),
(81, '[ [ 1549.79296875, -1677.94140625, 5.81875, 0, 0 ] ]'),
(82, '[ [ 251.5419921875, 76.294921875, 1003.240625, 6, 16 ] ]'),
(83, '[ [ 1788.8193359375, -1148.8857421875, 23.38417587280274, 0, 0 ] ]'),
(84, '[ [ 2511.673828125, -2021.0517578125, 13.15404472351074, 0, 0 ] ]'),
(85, '[ [ 2504.5107421875, -2003.708984375, 13.146875, 0, 0 ] ]'),
(87, '[ [ -2087.6572265625, -499.001953125, 34.9359375, 0, 0 ] ]'),
(88, '[ [ 2311.8876953125, -1645.328125, 14.42704734802246, 0, 0 ] ]'),
(89, '[ [ -2171.1591796875, 646.5517578125, 1051.975, 1, 948 ] ]'),
(90, '[ [ 222.07421875, 121.650390625, 1002.81875, 10, 849 ] ]'),
(91, '[ [ 997.607421875, -647.39453125, 121.1521850585937, 0, 0 ] ]'),
(92, '[ [ 24.85546875, 1347.880859375, 1088.475, 10, 885 ] ]'),
(93, '[ [ 1413.443359375, 259.3896484375, 19.1546875, 0, 0 ] ]'),
(94, '[ [ -2714.9365234375, -314.38671875, 6.772498226165771, 0, 0 ] ]'),
(95, '[ [ 375.1107482910156, -2065.52978515625, 8.218443489074707, 0, 0 ] ]'),
(96, '[ [ 1670.5830078125, -1744.5751953125, 13.14676818847656, 0, 0 ] ]'),
(97, '[ [ 151.4013671875, -1946.4873046875, 3.3734375, 0, 0 ] ]'),
(98, '[ [ 874.1982421875, -1567.970703125, 13.13908157348633, 0, 0 ] ]'),
(99, '[ [ 1836.90625, -1687.6669921875, 12.92837677001953, 0, 0 ] ]'),
(105, '[ [ -1676.91015625, 417.537109375, 6.7796875, 0, 0 ] ]'),
(106, '[ [ 1662.17578125, -1218.623046875, 200.1234375, 0, 0 ] ]'),
(110, '[ [ 1553.4423828125, -1708.603515625, 5.81875, 0, 0 ] ]'),
(114, '[ [ 1017.517578125, -1122.611328125, 23.4654899597168, 0, 0 ] ]'),
(115, '[ [ 731.357421875, -540.642578125, 15.9359375, 0, 0 ] ]'),
(116, '[ [ 1412.7802734375, 6.8076171875, 1000.521875, 1, 1249 ] ]'),
(118, '[ [ 1383.6845703125, 6.734375, 1000.515283203125, 1, 1208 ] ]'),
(119, '[ [ 1419.2275390625, -1.6640625, 1000.527612304688, 1, 1212 ] ]'),
(120, '[ [ 1282.7021484375, 6.7578125, 1000.61220703125, 18, 1026 ] ]'),
(123, '[ [ 809.412109375, -762.591796875, 76.13136444091796, 0, 0 ] ]'),
(124, '[ [ 242.37109375, 1119.478515625, 1080.5921875, 5, 963 ] ]'),
(125, '[ [ 1017.7490234375, -1336.7216796875, 13.146875, 0, 0 ] ]'),
(133, '[ [ 1050.2138671875, -641.666015625, 119.7171875, 0, 0 ] ]'),
(136, '[ [ -2050.435546875, -2534.271484375, 30.22707901000977, 0, 0 ] ]'),
(137, '[ [ 786.224609375, -762.033203125, 73.16066131591796, 0, 0 ] ]'),
(139, '[ [ 204.59765625, -1407.171875, 51.209375, 0, 0 ] ]'),
(140, '[ [ 1240.994140625, -2035.4091796875, 59.59524688720703, 0, 0 ] ]'),
(141, '[ [ 1240.962890625, -2038.642578125, 59.59350738525391, 0, 0 ] ]'),
(142, '[ [ 917.2509765625, -917.5361328125, 42.2015625, 0, 0 ] ]'),
(145, '[ [ 753.18359375, 1443.3154296875, 1102.303125, 6, 1630 ] ]'),
(147, '[ [ 1276.0146484375, 6.888671875, 1000.623620605469, 18, 1633 ] ]'),
(149, '[ [ -2172.763671875, -2483.69140625, 31.4162727355957, 0, 0 ] ]'),
(150, '[ [ 1546.599609375, -1679.7763671875, 13.15998229980469, 0, 0 ] ]'),
(152, '[ [ 1309.625, -894.5966796875, 39.178125, 0, 0 ] ]'),
(153, '[ [ 2905.4052734375, -587.4384765625, 10.92860279083252, 0, 0 ] ]'),
(154, '[ [ -979.484375, 1066.38671875, 1344.568505859375, 10, 831 ] ]'),
(156, '[ [ 1738.00390625, -1151.7578125, 23.428125, 0, 0 ] ]'),
(157, '[ [ 153.38671875, -63.2529296875, 1.178125, 0, 0 ] ]'),
(158, '[ [ 1500.4765625, 1303.8984375, 1092.8890625, 3, 1652 ] ]'),
(159, '[ [ 2855.17578125, -1524.1025390625, 10.69644222259521, 0, 0 ] ]'),
(161, '[ [ 1285.498046875, -1332.232421875, 13.14913520812988, 0, 0 ] ]'),
(162, '[ [ 1673.9091796875, -1690.36328125, 21.03125915527344, 0, 0 ] ]'),
(163, '[ [ 1596.4833984375, -1633.900390625, 13.31875, 0, 0 ] ]'),
(166, '[ [ -825.4658203125, 513.4453125, 1357.426904296875, 1, 1742 ] ]'),
(167, '[ [ 1419.7109375, -3.9677734375, 1000.521875, 1, 1845 ] ]'),
(168, '[ [ 259.8681640625, 107.44140625, 1002.81875, 10, 1755 ] ]'),
(171, '[ [ 1595.98046875, -1275.3271484375, 17.053125, 0, 0 ] ]'),
(172, '[ [ 1592.22265625, -1272.9052734375, 17.07878646850586, 0, 0 ] ]'),
(188, '[ [ 2369.5263671875, -1131.4423828125, 1050.475, 8, 470 ] ]'),
(190, '[ [ 267.240234375, 107.9326171875, 1004.2171875, 10, 1755 ] ]'),
(193, '[ [ 274.51171875, 122.0869140625, 1004.2171875, 10, 1755 ] ]'),
(194, '[ [ 1465.283203125, -996.078125, 26.3421875, 0, 0 ] ]'),
(195, '[ [ 1530.14453125, -1661.2685546875, 5.81875, 0, 0 ] ]'),
(196, '[ [ 1530.828125, -1674.46484375, 5.490625, 0, 0 ] ]'),
(198, '[ [ 2428.724609375, -1223.2099609375, 25.01195297241211, 0, 0 ] ]'),
(199, '[ [ 1399.9921875, 467.6845703125, 19.77496109008789, 0, 0 ] ]'),
(200, '[ [ 2810.2861328125, -1586.9150390625, 10.70520553588867, 0, 0 ] ]'),
(201, '[ [ 1897.875, -1352.1806640625, 13.07599983215332, 0, 0 ] ]'),
(203, '[ [ 2259.0966796875, -1213.5400390625, 23.56875, 0, 0 ] ]'),
(205, '[ [ 1968.5849609375, -2183.6728515625, 13.146875, 0, 0 ] ]'),
(206, '[ [ 1007.4775390625, -640.025390625, 120.6651245117187, 0, 0 ] ]'),
(209, '[ [ 1089.181640625, -649.046875, 113.2484375, 0, 0 ] ]'),
(210, '[ [ 1998.6904296875, -1381.5048828125, 996.7932983398438, 0, 16 ] ]'),
(211, '[ [ 1982.4990234375, -2371.6162109375, 13.146875, 0, 0 ] ]'),
(212, '[ [ 1138.4482421875, -2424.9189453125, 11.89170799255371, 0, 0 ] ]'),
(213, '[ [ 2004.6787109375, -1399.3681640625, 996.778955078125, 0, 16 ] ]'),
(214, '[ [ 1861.509765625, -1398.1279296875, 13.1625, 0, 0 ] ]');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `liftek`
--

CREATE TABLE `liftek` (
  `id` int(11) NOT NULL,
  `enter` varchar(1000) NOT NULL,
  `exitgeci` varchar(1000) NOT NULL DEFAULT '[ false ]'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- A tábla adatainak kiíratása `liftek`
--

INSERT INTO `liftek` (`id`, `enter`, `exitgeci`) VALUES
(7, '[ [ 1172.9658203125, -1323.41015625, 15.39823627471924, 0, 0 ] ]', '[ [ 1170.4013671875, -1324.3974609375, 15.35604476928711, 0, 0 ] ]'),
(27, '[ [ 1160.611083984375, -1351.59375, 15.36604499816895, 0, 0 ] ]', '[ [ 1161.3671875, -1330.0849609375, 31.49436378479004, 0, 0 ] ]'),
(29, '[ [ 2362.919921875, -1127.4716796875, 1050.875, 777, 8 ] ]', '[ [ 2363.7724609375, -1127.3427734375, 1050.882568359375, 777, 8 ] ]'),
(33, '[ [ -2170.4814453125, 641.099609375, 1057.59375, 825, 1 ] ]', '[ [ -217.3974609375, 1402.7607421875, 27.7734375, 823, 18 ] ]'),
(35, '[ [ -2170.2783203125, 640.5615234375, 1057.590942382813, 873, 1 ] ]', '[ [ 1204.9033203125, 12.6650390625, 1000.921875, 872, 2 ] ]'),
(36, '[ [ 1548.529296875, -1364.3544921875, 326.2182922363281, 0, 0 ] ]', '[ [ 1571.466796875, -1336.1923828125, 16.484375, 0, 0 ] ]'),
(37, '[ [ 2193.3701171875, -1151.2490234375, 33.52404403686523, 0, 0 ] ]', '[ [ 2193.4814453125, -1139.2373046875, 1029.796875, 481, 15 ] ]'),
(38, '[ [ 2332.5224609375, -1144.0322265625, 1054.3046875, 919, 12 ] ]', '[ [ 2332.595703125, -1145.796875, 1054.296875, 919, 12 ] ]'),
(41, '[ [ 1963.3916015625, 1062.810546875, 994.46875, 648, 10 ] ]', '[ [ -2026.8740234375, -104.3603515625, 1035.171875, 944, 3 ] ]'),
(42, '[ [ 1963.318359375, 973.1298828125, 994.46875, 648, 10 ] ]', '[ [ -2171.0576171875, 646.4638671875, 1057.59375, 948, 1 ] ]'),
(43, '[ [ -268.1240234375, 1458.345703125, 1084.3671875, 81, 4 ] ]', '[ [ 397.8212890625, -1292.013671875, 50.04851531982422, 0, 0 ] ]'),
(45, '[ [ 1143.0205078125, 6.1640625, 1000.6796875, 973, 12 ] ]', '[ [ 86.15625, 1323.0927734375, 1083.859375, 974, 9 ] ]'),
(46, '[ [ 2231.7578125, -1112.2763671875, 1050.8828125, 989, 5 ] ]', '[ [ 2271.337890625, 1652.5263671875, 1084.234375, 986, 1 ] ]'),
(47, '[ [ 2231.736328125, -1112.3388671875, 1050.8828125, 990, 5 ] ]', '[ [ 2271.3369140625, 1633.59765625, 1084.234375, 986, 1 ] ]'),
(48, '[ [ 2231.7353515625, -1112.3046875, 1050.8828125, 991, 5 ] ]', '[ [ 2266.21484375, 1662.6826171875, 1084.234375, 986, 1 ] ]'),
(49, '[ [ 2262.7880859375, -1216.7158203125, 1049.0234375, 994, 10 ] ]', '[ [ 2264.404296875, 1619.50390625, 1090.4453125, 986, 1 ] ]'),
(50, '[ [ 236.984375, 1065.361328125, 1084.206665039063, 995, 6 ] ]', '[ [ 2264.3974609375, 1675.7490234375, 1090.4453125, 986, 1 ] ]'),
(51, '[ [ -2718.1708984375, -319.9375, 57.48726654052734, 0, 0 ] ]', '[ [ 2266.0478515625, 1642.259765625, 1084.234375, 986, 1 ] ]'),
(52, '[ [ 1460.2119140625, -1676.7626953125, 10430.3623046875, 0, 0 ] ]', '[ [ 627.3115234375, -571.7353515625, 17.91450119018555, 0, 0 ] ]'),
(53, '[ [ 1485.494140625, -1676.232421875, 10430.3623046875, 0, 0 ] ]', '[ [ 610.9951171875, -583.494140625, 18.2109375, 0, 0 ] ]'),
(54, '[ [ 1700.5283203125, -1667.80078125, 20.21875, 1057, 18 ] ]', '[ [ 226.9072265625, 1287.1708984375, 1082.140625, 1067, 1 ] ]'),
(55, '[ [ 1708.7021484375, -1670.2578125, 23.70567321777344, 1057, 18 ] ]', '[ [ 227.0068359375, 1287.1728515625, 1082.140625, 1068, 1 ] ]'),
(56, '[ [ 1708.7021484375, -1664.904296875, 23.70436477661133, 1057, 18 ] ]', '[ [ 227.0068359375, 1287.1708984375, 1082.140625, 1069, 1 ] ]'),
(57, '[ [ 1708.703125, -1659.771484375, 23.70310974121094, 1057, 18 ] ]', '[ [ 226.8896484375, 1287.30859375, 1082.140625, 1070, 1 ] ]'),
(58, '[ [ 1708.703125, -1654.517578125, 23.70182609558105, 1057, 18 ] ]', '[ [ 227.0078125, 1287.1708984375, 1082.140625, 1071, 1 ] ]'),
(59, '[ [ 1708.7021484375, -1649.306640625, 23.6953125, 1057, 18 ] ]', '[ [ 227.0078125, 1287.1708984375, 1082.140625, 1072, 1 ] ]'),
(60, '[ [ 1708.7080078125, -1659.7568359375, 27.1953125, 1057, 18 ] ]', '[ [ 226.8427734375, 1287.30859375, 1082.140625, 1074, 1 ] ]'),
(61, '[ [ 1735.1025390625, -1660.1181640625, 23.71860504150391, 1057, 18 ] ]', '[ [ 226.8759765625, 1287.287109375, 1082.140625, 1075, 1 ] ]'),
(62, '[ [ 1735.0830078125, -1654.0517578125, 23.7319221496582, 1057, 18 ] ]', '[ [ 227.0078125, 1287.171875, 1082.140625, 1076, 1 ] ]'),
(63, '[ [ 1735.0654296875, -1648.2216796875, 23.74472427368164, 1057, 18 ] ]', '[ [ 227.0078125, 1287.171875, 1082.140625, 1077, 1 ] ]'),
(68, '[ [ -217.513671875, 1402.8095703125, 27.7734375, 1294, 18 ] ]', '[ [ 223.5, 1288.384765625, 1082.1328125, 1307, 1 ] ]'),
(73, '[ [ 1701.12890625, -1667.947265625, 20.21875, 1466, 18 ] ]', '[ [ 475.2890625, -11.2998046875, 1003.6953125, 1473, 17 ] ]'),
(75, '[ [ 2316.3125, -1143.7236328125, 1054.3046875, 1488, 12 ] ]', '[ [ 941.0532836914063, -607.88134765625, 133.2220153808594, 0, 0 ] ]'),
(77, '[ [ 2215.9150390625, -1075.1748046875, 1050.484375, 1660, 1 ] ]', '[ [ 1210.751953125, 4.7138671875, 1000.921875, 1635, 2 ] ]'),
(79, '[ [ 1285.59375, -1349.921875, 13.56691074371338, 0, 0 ] ]', '[ [ 1291.404296875, -1324.9921875, 18.86064147949219, 0, 0 ] ]'),
(82, '[ [ 350.013671875, 178.6240234375, 1014.1875, 776, 3 ] ]', '[ [ 1117.8095703125, -2029.4345703125, 74.4296875, 0, 0 ] ]'),
(87, '[ [ 964.044921875, -53.1171875, 1001.124572753906, 1167, 3 ] ]', '[ [ 1711.0029296875, -1644.21484375, 27.20138359069824, 1839, 18 ] ]'),
(88, '[ [ 931.771484375, -919.1728515625, 42.6015625, 0, 0 ] ]', '[ false ]'),
(89, '[ [ 928.7802734375, -916.6171875, 42.6015625, 0, 0 ] ]', '[ [ 1701.2236328125, -1668.0576171875, 20.21875, 1839, 18 ] ]'),
(91, '[ [ 2233.1884765625, -1159.7646484375, 25.890625, 0, 0 ] ]', '[ [ 2214.62890625, -1150.509765625, 1025.796875, 481, 15 ] ]'),
(93, '[ [ 1210.9013671875, 5.17578125, 1000.921875, 1849, 2 ] ]', '[ [ 2419.814453125, -1214.2080078125, 36.03128051757813, 0, 0 ] ]'),
(94, '[ [ 1766.150390625, -2261.7890625, 1.978901863098145, 0, 0 ] ]', '[ [ 1765.2822265625, -2273.0986328125, 26.79602241516113, 0, 0 ] ]'),
(95, '[ [ 285.8662109375, -86.2861328125, 1001.522888183594, 505, 4 ] ]', '[ [ 1368.384765625, -1279.74609375, 13.546875, 0, 0 ] ]'),
(97, '[ [ 1568.6396484375, -1689.970703125, 6.21875, 0, 0 ] ]', '[ [ 1564.873046875, -1666.896484375, 28.39560699462891, 0, 0 ] ]'),
(99, '[ [ -2676.0458984375, 1392.517578125, 918.3515625, 1890, 3 ] ]', '[ [ 948.48828125, 2177.9501953125, 1011.0234375, 1894, 1 ] ]'),
(100, '[ [ 2826.078125, -1536.2900390625, 11.09375, 0, 0 ] ]', '[ [ 226.4287109375, 117.4501953125, 999.0482788085938, 1755, 10 ] ]'),
(101, '[ [ 2282.2890625, -1641.21484375, 15.88978862762451, 0, 0 ] ]', '[ [ 2279.33203125, -1645.3828125, -7.834375381469727, 0, 0 ] ]'),
(104, '[ [ 2009.0283203125, -1398.5283203125, 997.1854858398438, 16, 0 ] ]', '[ [ 1554.5615234375, -1675.5849609375, 16.1953125, 0, 0 ] ]'),
(105, '[ [ 1524.84765625, -1677.9404296875, 5.890625, 0, 0 ] ]', '[ [ 1976.0478515625, -1392.376953125, 997.178955078125, 16, 0 ] ]'),
(106, '[ [ 945.2661743164063, -619.22021484375, 121.2845230102539, 0, 0 ] ]', '[ [ 943.4888305664063, -607.73974609375, 133.2220153808594, 0, 0 ] ]');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `logpp`
--

CREATE TABLE `logpp` (
  `id` varchar(255) NOT NULL,
  `date` date NOT NULL,
  `tel` text NOT NULL,
  `text` text NOT NULL,
  `provider` text NOT NULL,
  `sms_id` text NOT NULL,
  `tarifa` text NOT NULL,
  `newpp` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `logs`
--

CREATE TABLE `logs` (
  `dbid` int(255) NOT NULL,
  `admin` varchar(50) NOT NULL DEFAULT 'ISMERETLEN',
  `target` varchar(100) NOT NULL DEFAULT '',
  `system` varchar(255) NOT NULL,
  `content` mediumtext NOT NULL,
  `date` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- A tábla adatainak kiíratása `logs`
--

INSERT INTO `logs` (`dbid`, `admin`, `target`, `system`, `content`, `date`) VALUES
(1, 'CouldnoT', '', 'Donate', '!DeDo#6486 donated for a mafia.', '2020-04-09 12:59:10'),
(2, 'CouldnoT', '', 'Promotion', 'Mr.OMAR was promoted to the owner of the server.', '2020-04-09 12:59:13'),
(3, 'CouldnoT', '', 'Promotion', 'Sniko was promoted to the supervisor of the server.', '2020-04-09 12:59:28'),
(4, 'CouldnoT', '', 'Promotion', 'Dedo was promoted to Server Manager.', '2020-04-09 13:07:07'),
(5, 'CouldnoT', '', 'Promotion', 'SAIHE CAPOO was promoted to Support members.', '2020-04-09 13:07:32'),
(6, 'CouldnoT', '', 'Promotion', 'Takila was promoted to Moderator.', '2020-04-09 13:07:32'),
(7, 'CouldnoT', '', 'Launch', 'Server was launched.', '2020-05-09 12:00:00');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `luckywheels`
--

CREATE TABLE `luckywheels` (
  `id` int(11) NOT NULL,
  `pos` varchar(500) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- A tábla adatainak kiíratása `luckywheels`
--

INSERT INTO `luckywheels` (`id`, `pos`) VALUES
(7, '[ [ -2399.01953125, -592.1171875, 132.6484375, 0, 0, 65.85031127929688, 0, 0 ] ]');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `mdcaccounts`
--

CREATE TABLE `mdcaccounts` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `pass` varchar(300) NOT NULL,
  `online` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- A tábla adatainak kiíratása `mdcaccounts`
--

INSERT INTO `mdcaccounts` (`id`, `username`, `pass`, `online`) VALUES
(3, 'Zorty', 'surasura', 0);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `mdcwantedplayers`
--

CREATE TABLE `mdcwantedplayers` (
  `id` int(11) NOT NULL,
  `name` varchar(40) NOT NULL,
  `location` varchar(100) NOT NULL,
  `indok` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `mdcwantedvehicles`
--

CREATE TABLE `mdcwantedvehicles` (
  `id` int(11) NOT NULL,
  `name` varchar(70) NOT NULL,
  `location` varchar(70) NOT NULL,
  `indok` varchar(200) NOT NULL,
  `rendszam` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- A tábla adatainak kiíratása `mdcwantedvehicles`
--

INSERT INTO `mdcwantedvehicles` (`id`, `name`, `location`, `indok`, `rendszam`) VALUES
(1, 'asd', 'asd', 'asd', 'Zorty');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `mobil_c`
--

CREATE TABLE `mobil_c` (
  `id` int(255) NOT NULL,
  `owner_n` int(11) NOT NULL,
  `name` text CHARACTER SET utf8 NOT NULL,
  `number` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `phones`
--

CREATE TABLE `phones` (
  `id` int(255) NOT NULL,
  `number` int(20) NOT NULL,
  `sms` varchar(20000) NOT NULL DEFAULT '[ [ ] ]',
  `calls` varchar(2000) NOT NULL DEFAULT '[ [ ] ]',
  `wallpaper` int(3) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `plants`
--

CREATE TABLE `plants` (
  `id` int(11) NOT NULL,
  `pos` varchar(255) DEFAULT '[ false ]',
  `type` int(2) NOT NULL,
  `water` int(3) NOT NULL DEFAULT 100,
  `increase` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `playerfactions`
--

CREATE TABLE `playerfactions` (
  `id` int(11) NOT NULL,
  `dbid` int(11) NOT NULL,
  `rank` int(11) NOT NULL DEFAULT 1,
  `faction` int(11) NOT NULL,
  `leader` int(2) NOT NULL DEFAULT 0,
  `dutyskin` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- A tábla adatainak kiíratása `playerfactions`
--

INSERT INTO `playerfactions` (`id`, `dbid`, `rank`, `faction`, `leader`, `dutyskin`) VALUES
(5, 8, 1, 63, 0, 0),
(6, 8, 1, 53, 1, 132),
(7, 8, 1, 60, 0, 0);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `szefek`
--

CREATE TABLE `szefek` (
  `dbid` int(11) NOT NULL,
  `pos` varchar(1000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `szemelyik`
--

CREATE TABLE `szemelyik` (
  `id` int(255) NOT NULL,
  `name` varchar(50) NOT NULL,
  `gender` int(1) NOT NULL DEFAULT 1,
  `date` date NOT NULL,
  `exdate` date NOT NULL,
  `cardid` varchar(6) NOT NULL DEFAULT '000000'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- A tábla adatainak kiíratása `szemelyik`
--

INSERT INTO `szemelyik` (`id`, `name`, `gender`, `date`, `exdate`, `cardid`) VALUES
(7, 'Zorty R Wilson', 1, '2020-03-30', '2020-04-30', 'KGHVAJ');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `targyak`
--

CREATE TABLE `targyak` (
  `dbid` int(255) NOT NULL,
  `itemID` int(11) NOT NULL,
  `ownerID` int(11) NOT NULL,
  `slot` int(11) NOT NULL,
  `darab` int(11) NOT NULL,
  `ertek` int(11) NOT NULL,
  `allapot` int(11) NOT NULL,
  `ownerType` varchar(1000) NOT NULL,
  `egyebek` varchar(1000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- A tábla adatainak kiíratása `targyak`
--

INSERT INTO `targyak` (`dbid`, `itemID`, `ownerID`, `slot`, `darab`, `ertek`, `allapot`, `ownerType`, `egyebek`) VALUES
(488, 40, 8, 1, 1, 1, 100, 'player', '[ [ 0 ] ]'),
(489, 107, 8, 1, 1, 1, 100, 'player', '[ [ 0, [ \"Zorty R Wilson\", 1, \"2020.03.30.\", \"2020.04.30\" ] ] ]'),
(490, 40, 8, 2, 1, 2, 100, 'player', '[ [ 0 ] ]'),
(491, 40, 8, 3, 1, 3, 100, 'player', '[ [ 0 ] ]'),
(492, 40, 8, 4, 1, 4, 100, 'player', '[ [ 0 ] ]'),
(493, 40, 8, 5, 1, 5, 100, 'player', '[ [ 0 ] ]'),
(494, 40, 8, 6, 1, 6, 100, 'player', '[ [ 0 ] ]'),
(495, 47, 8, 2, 1, 7, 100, 'player', '[ [ 0 ] ]'),
(496, 48, 8, 3, 1, 4, 100, 'player', '[ [ 0 ] ]'),
(497, 97, 8, 4, 1, 10, 100, 'player', '[ [ 0 ] ]'),
(498, 17, 8, 1, 1, 0, 100, 'player', '[ [ 1 ] ]'),
(499, 31, 8, 2, 70, 0, 100, 'player', '[ [ 1 ] ]'),
(500, 29, 8, 3, 1, 0, 100, 'player', '[ [ 1 ] ]'),
(501, 87, 8, 4, 1, 0, 100, 'player', '[ [ 1 ] ]'),
(502, 27, 8, 5, 1, 1, 100, 'player', '[ [ 1 ] ]'),
(503, 88, 8, 5, 1, 1, 100, 'player', '[ [ 0, \"LSPD LEGLYOBB FEJLESZTO\" ] ]');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `utlevelek`
--

CREATE TABLE `utlevelek` (
  `id` int(255) NOT NULL,
  `name` varchar(50) NOT NULL,
  `gender` int(1) NOT NULL DEFAULT 1,
  `date` date NOT NULL,
  `exdate` date NOT NULL,
  `cardid` varchar(6) NOT NULL DEFAULT '000000'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- A tábla adatainak kiíratása `utlevelek`
--

INSERT INTO `utlevelek` (`id`, `name`, `gender`, `date`, `exdate`, `cardid`) VALUES
(4, 'Zorty R Wilson', 1, '2020-03-30', '2020-04-30', 'CRBAXH');

--
-- Indexek a kiírt táblákhoz
--

--
-- A tábla indexei `accounts`
--
ALTER TABLE `accounts`
  ADD PRIMARY KEY (`id`);

--
-- A tábla indexei `actionbar`
--
ALTER TABLE `actionbar`
  ADD PRIMARY KEY (`dbid`);

--
-- A tábla indexei `atmek`
--
ALTER TABLE `atmek`
  ADD PRIMARY KEY (`id`);

--
-- A tábla indexei `boltok`
--
ALTER TABLE `boltok`
  ADD PRIMARY KEY (`id`);

--
-- A tábla indexei `changelog`
--
ALTER TABLE `changelog`
  ADD PRIMARY KEY (`id`);

--
-- A tábla indexei `characters`
--
ALTER TABLE `characters`
  ADD PRIMARY KEY (`id`);

--
-- A tábla indexei `factions`
--
ALTER TABLE `factions`
  ADD PRIMARY KEY (`id`);

--
-- A tábla indexei `hengedelyek`
--
ALTER TABLE `hengedelyek`
  ADD PRIMARY KEY (`id`);

--
-- A tábla indexei `interiors`
--
ALTER TABLE `interiors`
  ADD PRIMARY KEY (`id`);

--
-- A tábla indexei `jarmuvek`
--
ALTER TABLE `jarmuvek`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id` (`id`),
  ADD KEY `id_2` (`id`);

--
-- A tábla indexei `jogsik`
--
ALTER TABLE `jogsik`
  ADD PRIMARY KEY (`id`);

--
-- A tábla indexei `kapuk`
--
ALTER TABLE `kapuk`
  ADD PRIMARY KEY (`id`);

--
-- A tábla indexei `kukak`
--
ALTER TABLE `kukak`
  ADD PRIMARY KEY (`dbid`);

--
-- A tábla indexei `liftek`
--
ALTER TABLE `liftek`
  ADD PRIMARY KEY (`id`);

--
-- A tábla indexei `logs`
--
ALTER TABLE `logs`
  ADD PRIMARY KEY (`dbid`);

--
-- A tábla indexei `luckywheels`
--
ALTER TABLE `luckywheels`
  ADD PRIMARY KEY (`id`);

--
-- A tábla indexei `mdcaccounts`
--
ALTER TABLE `mdcaccounts`
  ADD PRIMARY KEY (`id`);

--
-- A tábla indexei `mdcwantedplayers`
--
ALTER TABLE `mdcwantedplayers`
  ADD PRIMARY KEY (`id`);

--
-- A tábla indexei `mdcwantedvehicles`
--
ALTER TABLE `mdcwantedvehicles`
  ADD PRIMARY KEY (`id`);

--
-- A tábla indexei `mobil_c`
--
ALTER TABLE `mobil_c`
  ADD PRIMARY KEY (`id`);

--
-- A tábla indexei `phones`
--
ALTER TABLE `phones`
  ADD PRIMARY KEY (`id`);

--
-- A tábla indexei `plants`
--
ALTER TABLE `plants`
  ADD PRIMARY KEY (`id`);

--
-- A tábla indexei `playerfactions`
--
ALTER TABLE `playerfactions`
  ADD PRIMARY KEY (`id`);

--
-- A tábla indexei `szefek`
--
ALTER TABLE `szefek`
  ADD PRIMARY KEY (`dbid`);

--
-- A tábla indexei `szemelyik`
--
ALTER TABLE `szemelyik`
  ADD PRIMARY KEY (`id`);

--
-- A tábla indexei `targyak`
--
ALTER TABLE `targyak`
  ADD PRIMARY KEY (`dbid`);

--
-- A tábla indexei `utlevelek`
--
ALTER TABLE `utlevelek`
  ADD PRIMARY KEY (`id`);

--
-- A kiírt táblák AUTO_INCREMENT értéke
--

--
-- AUTO_INCREMENT a táblához `accounts`
--
ALTER TABLE `accounts`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT a táblához `actionbar`
--
ALTER TABLE `actionbar`
  MODIFY `dbid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=150;

--
-- AUTO_INCREMENT a táblához `atmek`
--
ALTER TABLE `atmek`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=118;

--
-- AUTO_INCREMENT a táblához `boltok`
--
ALTER TABLE `boltok`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=82;

--
-- AUTO_INCREMENT a táblához `changelog`
--
ALTER TABLE `changelog`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=314;

--
-- AUTO_INCREMENT a táblához `factions`
--
ALTER TABLE `factions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=70;

--
-- AUTO_INCREMENT a táblához `hengedelyek`
--
ALTER TABLE `hengedelyek`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT a táblához `interiors`
--
ALTER TABLE `interiors`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1916;

--
-- AUTO_INCREMENT a táblához `jarmuvek`
--
ALTER TABLE `jarmuvek`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT a táblához `jogsik`
--
ALTER TABLE `jogsik`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT a táblához `kapuk`
--
ALTER TABLE `kapuk`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=135;

--
-- AUTO_INCREMENT a táblához `kukak`
--
ALTER TABLE `kukak`
  MODIFY `dbid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=216;

--
-- AUTO_INCREMENT a táblához `liftek`
--
ALTER TABLE `liftek`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=107;

--
-- AUTO_INCREMENT a táblához `logs`
--
ALTER TABLE `logs`
  MODIFY `dbid` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=78;

--
-- AUTO_INCREMENT a táblához `luckywheels`
--
ALTER TABLE `luckywheels`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT a táblához `mdcaccounts`
--
ALTER TABLE `mdcaccounts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT a táblához `mdcwantedplayers`
--
ALTER TABLE `mdcwantedplayers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT a táblához `mdcwantedvehicles`
--
ALTER TABLE `mdcwantedvehicles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT a táblához `mobil_c`
--
ALTER TABLE `mobil_c`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT a táblához `phones`
--
ALTER TABLE `phones`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT a táblához `plants`
--
ALTER TABLE `plants`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT a táblához `playerfactions`
--
ALTER TABLE `playerfactions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT a táblához `szefek`
--
ALTER TABLE `szefek`
  MODIFY `dbid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT a táblához `szemelyik`
--
ALTER TABLE `szemelyik`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT a táblához `targyak`
--
ALTER TABLE `targyak`
  MODIFY `dbid` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=504;

--
-- AUTO_INCREMENT a táblához `utlevelek`
--
ALTER TABLE `utlevelek`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
