-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Gép: 127.0.0.1
-- Létrehozás ideje: 2024. Aug 15. 15:41
-- Kiszolgáló verziója: 10.4.32-MariaDB
-- PHP verzió: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Adatbázis: `application`
--

DELIMITER $$
--
-- Eljárások
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `closeMonth` (IN `emp_` INT, IN `year_` INT, IN `month_` INT, IN `editor_` INT, IN `status_` INT)   BEGIN
select count(*) 
into @value
from register_closedmonths 
where uid = emp_ and year = year_ and month = month_;


IF @value =0 THEN
    insert into register_closedmonths(uid,year,month,editor) 
	values(emp_,year_,month_,editor_);
ELSE
 update register_closedmonths 
 	set `status` = status_, editor = editor_
 where uid = emp_ and year =year_ and month = month_;
END IF;





          
 

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `createUser` (IN `name_` TEXT, IN `jobCode_` INT, IN `birthYear_` INT, IN `childCount_` INT, IN `comments_` TEXT, IN `location_` INT, IN `loginName_` TEXT, IN `supervisorId_` INT)   BEGIN
insert into users(userName,loginName,jobCode,birthYear,childCount,supervisorId,`passWord`)
values(name_, md5(loginName_), jobCode_, birthYear_, childCount_, supervisorId_, md5("Salisbury1") );

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `emp_admin_age` (IN `emp_` INT, IN `age_` INT)   BEGIN
update users set birthYear = age_ where id = emp_;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `emp_admin_auth` (IN `emp_` INT, IN `jobCode_` INT)   BEGIN

update users set jobCode = jobCode_ where id = emp_;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `emp_admin_childs` (IN `emp_` INT, IN `childs_` INT)   BEGIN

update users set childCount = childs_ where id = emp_;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `emp_admin_comments` (IN `emp_` INT, IN `comments_` TEXT)   BEGIN

update users set comments = comments_ where id = emp_;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `emp_admin_location` (IN `emp_` INT, IN `location_` INT)   BEGIN
update users set location = location_ where id = emp_;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `emp_admin_name` (IN `emp_` INT, IN `name_` TEXT)   BEGIN

update users set userName = name_ where id = emp_;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `emp_admin_supervisor` (IN `emp_` INT, IN `supervisor_` INT)   BEGIN
update users set supervisorId = supervisor_ where id = emp_;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getHolyDays` (IN `jwt_` TEXT)   BEGIN
select 
birthYear,
childCount,
count(register.type) as holydays
from users
left join register on register.uid = users.id
where jwt = jwt and register.type=2 and year(register.date) = year(curdate())
;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getLogEmpDay` (IN `emp` INT, IN `time` DATE)   BEGIN
select 
users.userName as editorName,
register_logs.date,
type

from register_logs
left join users on users.id = register_logs.editor
where register_logs.uid = emp and register_logs.date = time;


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getPlaces` ()   BEGIN
select id,locationName from locations;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getRegister` (IN `emp` INT, IN `time` DATE)   BEGIN
select count(*) from register where uid = emp and date = time;


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getRegisterByUser` (IN `emp` INT, IN `yearNo` DATE, IN `monthNo` INT)   BEGIN

select date,type,uid from register where uid = emp
and year(date) = yearNo
and month(date) = monthNo;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getRights` ()   BEGIN
select jobCode, jobName from user_job_titles order by jobName;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getUserMonthStatus` (IN `emp_` INT, IN `year_` INT, IN `month_` INT)   BEGIN
select `status` 
into @value
from register_closedmonths 
where uid = emp_ and year = year_ and month = month_;


IF @value is null THEN
    select 0;
ELSE
 	select @value;
END IF;


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `list_juniors` (IN `emp` INT, IN `status_` INT)   BEGIN
select
users.id, 
users.userName, 
sup.userName as supervisorName,
users.supervisorId 
from users
left join users sup on sup.id = users.supervisorId

where users.active = status_ and 
( users.supervisorId = emp || users.id = emp);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `list_users` (IN `status_` INT)   BEGIN

select
users.id, 
users.userName, 
sup.userName as supervisorName,
users.supervisorId
from users
left join users sup on sup.id = users.supervisorId


where users.active = status_;


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `loadRegister` (IN `emp` INT, IN `yearNo` INT, IN `monthNo` INT)   BEGIN

select `date`,uid,type,userName from register 
left join users on users.id = register.uid


where uid = emp and year(`date`) = yearNo
and month(`date`) = monthNo;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `searchEmp` (IN `emp_` TEXT)   BEGIN
select
users.id,
users.username,
user_job_titles.jobName,
users.birthYear,
users.childCount,
users.location,
users.jobCode,
users.comments,
supervisor.userName as supervisorName,
supervisor.id as supervisorId,
count(register.date) as holydays from users
left join user_job_titles on user_job_titles.jobCode = users.jobCode
left join register on register.uid = users.id
left join users supervisor on supervisor.id = users.supervisorId


where 
 users.userName like concat('%',emp_,'%')

group by users.id;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `setRegister` (IN `emp` INT, IN `time` DATE, IN `type` INT, IN `editor_` INT)   BEGIN

INSERT INTO `register`(`uid`, `date`,  `type`, editor) VALUES (emp, time, type, editor_);
insert into register_logs(`uid`,`date`,`type`, editor) values(emp, time, type, editor_);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateRegister` (IN `emp` INT, IN `time` DATE, IN `type_` INT, IN `editor_` INT)   BEGIN

update `register` set `type` = type_ 
where `date` = time and  uid = emp;
insert into register_logs(`uid`,`date`,`type`, editor) 
values(emp, time, type_, editor_);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `userToken` (IN `token` VARCHAR(255))   BEGIN
select id,jobCode,lastLogin from users where jwt = token;

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `locations`
--

CREATE TABLE `locations` (
  `id` int(11) NOT NULL,
  `locationName` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- A tábla adatainak kiíratása `locations`
--

INSERT INTO `locations` (`id`, `locationName`) VALUES
(1, 'Backoffice'),
(2, 'Restaurátorműhely'),
(3, 'CEO'),
(4, 'Terep'),
(5, 'GIS');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `register`
--

CREATE TABLE `register` (
  `id` int(11) NOT NULL,
  `uid` int(11) NOT NULL,
  `date` date NOT NULL,
  `created` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `type` int(11) NOT NULL,
  `editor` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- A tábla adatainak kiíratása `register`
--

INSERT INTO `register` (`id`, `uid`, `date`, `created`, `type`, `editor`) VALUES
(1, 5, '2024-08-01', '2024-08-09 12:06:20', 0, 2),
(2, 2, '2024-08-01', '2024-08-09 12:08:04', 1, 2),
(3, 1, '2024-08-01', '2024-08-13 11:06:43', 2, 1),
(4, 2, '2024-08-13', '2024-08-09 12:08:14', 0, 2),
(5, 2, '2024-08-02', '2024-08-09 12:08:55', 3, 2),
(6, 2, '2024-09-01', '2024-08-09 12:09:26', 2, 2),
(7, 2, '2024-08-03', '2024-08-12 07:31:16', 0, 2),
(8, 2, '2024-09-02', '2024-08-12 08:24:05', 0, 2),
(9, 1, '2024-08-02', '2024-08-13 11:05:54', 1, 1),
(10, 1, '2024-08-03', '2024-08-13 11:07:02', 2, 1);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `register_closedmonths`
--

CREATE TABLE `register_closedmonths` (
  `id` int(11) NOT NULL,
  `uid` int(11) NOT NULL,
  `year` int(11) NOT NULL,
  `month` int(11) NOT NULL,
  `modified` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `editor` int(11) NOT NULL,
  `status` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- A tábla adatainak kiíratása `register_closedmonths`
--

INSERT INTO `register_closedmonths` (`id`, `uid`, `year`, `month`, `modified`, `editor`, `status`) VALUES
(1, 1, 2024, 8, '2024-08-15 10:06:24', 1, 1),
(2, 2, 2024, 8, '2024-08-09 12:09:00', 2, 1),
(3, 2, 2024, 9, '2024-08-12 08:24:44', 2, 1);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `register_logs`
--

CREATE TABLE `register_logs` (
  `id` int(11) NOT NULL,
  `uid` int(11) NOT NULL,
  `date` date NOT NULL,
  `type` int(11) NOT NULL,
  `created` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `editor` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- A tábla adatainak kiíratása `register_logs`
--

INSERT INTO `register_logs` (`id`, `uid`, `date`, `type`, `created`, `editor`) VALUES
(1, 5, '2024-08-01', 1, '2024-08-09 10:18:37', 2),
(2, 5, '2024-08-01', 2, '2024-08-09 10:18:42', 2),
(3, 2, '2024-08-01', 1, '2024-08-09 10:36:25', 2),
(4, 1, '2024-08-01', 1, '2024-08-09 10:37:49', 1),
(5, 1, '2024-08-01', 2, '2024-08-09 10:37:49', 1),
(6, 2, '2024-08-01', 2, '2024-08-09 10:58:26', 2),
(7, 2, '2024-08-01', 3, '2024-08-09 10:58:27', 2),
(8, 2, '2024-08-01', 0, '2024-08-09 10:58:28', 2),
(9, 1, '2024-08-01', 3, '2024-08-09 12:06:16', 2),
(10, 1, '2024-08-01', 0, '2024-08-09 12:06:18', 2),
(11, 5, '2024-08-01', 3, '2024-08-09 12:06:20', 2),
(12, 5, '2024-08-01', 0, '2024-08-09 12:06:20', 2),
(13, 2, '2024-08-01', 1, '2024-08-09 12:08:04', 2),
(14, 2, '2024-08-13', 1, '2024-08-09 12:08:10', 2),
(15, 2, '2024-08-13', 2, '2024-08-09 12:08:12', 2),
(16, 2, '2024-08-13', 3, '2024-08-09 12:08:13', 2),
(17, 2, '2024-08-13', 0, '2024-08-09 12:08:14', 2),
(18, 2, '2024-08-02', 1, '2024-08-09 12:08:54', 2),
(19, 2, '2024-08-02', 2, '2024-08-09 12:08:55', 2),
(20, 2, '2024-08-02', 3, '2024-08-09 12:08:55', 2),
(21, 2, '2024-09-01', 1, '2024-08-09 12:09:24', 2),
(22, 2, '2024-09-01', 2, '2024-08-09 12:09:25', 2),
(23, 2, '2024-09-01', 3, '2024-08-09 12:09:25', 2),
(24, 2, '2024-09-01', 0, '2024-08-09 12:09:26', 2),
(25, 2, '2024-09-01', 1, '2024-08-09 12:09:26', 2),
(26, 2, '2024-09-01', 2, '2024-08-09 12:09:26', 2),
(27, 2, '2024-08-03', 1, '2024-08-12 07:31:13', 2),
(28, 2, '2024-08-03', 2, '2024-08-12 07:31:13', 2),
(29, 2, '2024-08-03', 3, '2024-08-12 07:31:16', 2),
(30, 2, '2024-08-03', 0, '2024-08-12 07:31:16', 2),
(31, 2, '2024-09-02', 1, '2024-08-12 08:24:01', 2),
(32, 2, '2024-09-02', 2, '2024-08-12 08:24:02', 2),
(33, 2, '2024-09-02', 3, '2024-08-12 08:24:04', 2),
(34, 2, '2024-09-02', 0, '2024-08-12 08:24:05', 2),
(35, 1, '2024-08-01', 1, '2024-08-13 10:45:36', 1),
(36, 1, '2024-08-02', 1, '2024-08-13 11:05:54', 1),
(37, 1, '2024-08-03', 1, '2024-08-13 11:05:54', 1),
(38, 1, '2024-08-03', 2, '2024-08-13 11:05:55', 1),
(39, 1, '2024-08-03', 3, '2024-08-13 11:06:06', 1),
(40, 1, '2024-08-03', 0, '2024-08-13 11:06:07', 1),
(41, 1, '2024-08-01', 2, '2024-08-13 11:06:43', 1),
(42, 1, '2024-08-03', 1, '2024-08-13 11:06:57', 1),
(43, 1, '2024-08-03', 2, '2024-08-13 11:06:57', 1),
(44, 1, '2024-08-03', 3, '2024-08-13 11:06:59', 1),
(45, 1, '2024-08-03', 0, '2024-08-13 11:07:00', 1),
(46, 1, '2024-08-03', 1, '2024-08-13 11:07:01', 1),
(47, 1, '2024-08-03', 2, '2024-08-13 11:07:02', 1);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `loginName` text DEFAULT NULL,
  `userName` varchar(255) DEFAULT NULL,
  `passWord` text NOT NULL,
  `jobCode` int(11) NOT NULL,
  `jwt` varchar(255) NOT NULL,
  `lastLogin` datetime NOT NULL DEFAULT current_timestamp(),
  `active` int(11) NOT NULL DEFAULT 1,
  `supervisorId` int(11) NOT NULL,
  `birthYear` int(11) NOT NULL DEFAULT 0,
  `childCount` int(11) NOT NULL DEFAULT 0,
  `comments` text NOT NULL,
  `location` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- A tábla adatainak kiíratása `users`
--

INSERT INTO `users` (`id`, `loginName`, `userName`, `passWord`, `jobCode`, `jwt`, `lastLogin`, `active`, `supervisorId`, `birthYear`, `childCount`, `comments`, `location`) VALUES
(1, 'c1f151e4eb35ea1d5e0216de9de106df', 'Mayer András', 'e3afed0047b08059d0fada10f400c1e5', 1, 'c1f151e4eb35ea1d5e0216de9de106df1723635728', '2024-08-07 07:59:39', 1, 12, 2000, 3, 'Minta\n1234\n\n', 1),
(2, '9da1f8e0aecc9d868bad115129706a77', 'test user', '9da1f8e0aecc9d868bad115129706a77', 2, '9da1f8e0aecc9d868bad115129706a771723451025', '2024-08-07 14:16:12', 1, 1, 2006, 0, '', 2),
(3, NULL, 'Test user 2', '', 2, '', '2024-08-07 17:36:29', 1, 0, 1988, 1, '', 1),
(4, NULL, 'Test user 3', '', 2, '', '2024-08-07 17:36:29', 1, 0, 2000, 2, '', 1),
(5, NULL, 'Test user 4', '', 2, '', '2024-08-07 17:36:29', 1, 1, 2010, 0, '', 1),
(6, NULL, 'Kresz László', '', 2, '', '2024-08-14 14:35:30', 1, 6, 2000, 0, '', 1),
(7, NULL, 'Huszár Emőke', '', 2, '', '2024-08-14 14:35:30', 1, 6, 2000, 0, '', 1),
(8, NULL, 'Béni Zsuzsanna Rita', '', 2, '', '2024-08-14 14:35:30', 1, 6, 2000, 0, '', 1),
(9, NULL, 'Szűcs Imre', '', 2, '', '2024-08-14 14:35:30', 1, 6, 2000, 0, '', 1),
(10, NULL, 'Pataki Edit', '', 2, '', '2024-08-14 14:35:30', 1, 6, 2000, 0, '', 1),
(11, NULL, 'Kondi-Gávainé Micskei Kitti', '', 2, '', '2024-08-14 14:35:30', 1, 6, 2000, 0, '', 1),
(12, NULL, 'Czene András', '', 2, '', '2024-08-14 14:35:30', 1, 6, 2000, 0, '', 1),
(13, NULL, 'Szűcs Imre', '', 2, '', '2024-08-14 14:35:30', 1, 6, 2000, 0, '', 1),
(14, NULL, 'Szabó Orsolya', '', 2, '', '2024-08-14 14:35:30', 1, 6, 2000, 0, '', 1),
(15, NULL, 'Dirner László', '', 2, '', '2024-08-14 14:35:30', 1, 6, 2000, 0, '', 1),
(16, NULL, 'Bokor Erzsébet Margit', '', 2, '', '2024-08-14 14:35:30', 1, 6, 2000, 0, '', 1),
(17, NULL, 'Kocsis-Buruzs Gábor', '', 2, '', '2024-08-14 14:35:30', 1, 17, 2000, 0, '', 2),
(18, NULL, 'Erdei-Brüll Barabás', '', 2, '', '2024-08-14 14:35:30', 1, 17, 2000, 0, '', 2),
(19, NULL, 'Fejes Bella', '', 2, '', '2024-08-14 14:35:30', 1, 17, 2000, 0, '', 2),
(20, NULL, 'Fekete Gertrúd Réka', '', 2, '', '2024-08-14 14:35:30', 1, 17, 2000, 0, '', 2),
(21, NULL, 'Gyapjas Attila Pál', '', 2, '', '2024-08-14 14:35:30', 1, 17, 2000, 0, '', 2),
(22, NULL, 'Gyapjas Nóra', '', 2, '', '2024-08-14 14:35:30', 1, 17, 2000, 0, '', 2),
(23, NULL, 'Horváth Orsolya Eszter', '', 2, '', '2024-08-14 14:35:30', 1, 17, 2000, 0, '', 2),
(24, NULL, 'Loósz Márton Bence', '', 2, '', '2024-08-14 14:35:30', 1, 17, 2000, 0, '', 2),
(25, NULL, 'Pócsik Bence', '', 2, '', '2024-08-14 14:35:30', 1, 17, 2000, 0, '', 2),
(26, NULL, 'Szabó Éva Emma', '', 2, '', '2024-08-14 14:35:30', 1, 17, 2000, 0, '', 2),
(27, NULL, 'Szabó Noémi', '', 2, '', '2024-08-14 14:35:30', 1, 17, 2000, 0, '', 2),
(28, NULL, 'Szklenár Fruzsina', '', 2, '', '2024-08-14 14:35:30', 1, 17, 2000, 0, '', 2),
(29, NULL, 'Szoliva Ildikó', '', 2, '', '2024-08-14 14:35:30', 1, 17, 2000, 0, '', 2),
(30, NULL, 'Hoffmann József', '', 2, '', '2024-08-14 14:35:30', 1, 30, 2000, 0, '', 3),
(31, NULL, 'Berta Norbert', '', 2, '', '2024-08-14 14:35:30', 1, 33, 2000, 0, '', 4),
(32, NULL, 'Bognár Máté', '', 2, '', '2024-08-14 14:35:30', 1, 33, 2000, 0, '', 4),
(33, NULL, 'Farkas Zoltán', '', 2, '', '2024-08-14 14:35:30', 1, 33, 2000, 0, '', 4),
(34, NULL, 'Földesi Anna Dorottya', '', 2, '', '2024-08-14 14:35:30', 1, 33, 2000, 0, '', 4),
(35, NULL, 'Hüse Asztrik Atilla', '', 2, '', '2024-08-14 14:35:30', 1, 33, 2000, 0, '', 4),
(36, NULL, 'Kántor Mátyás', '', 2, '', '2024-08-14 14:35:30', 1, 33, 2000, 0, '', 4),
(37, NULL, 'Major Péter', '', 2, '', '2024-08-14 14:35:30', 1, 33, 2000, 0, '', 4),
(38, NULL, 'Nagy Márton', '', 2, '', '2024-08-14 14:35:30', 1, 33, 2000, 0, '', 4),
(39, NULL, 'Pál Dalma', '', 2, '', '2024-08-14 14:35:30', 1, 33, 2000, 0, '', 4),
(40, NULL, 'Prander Péter', '', 2, '', '2024-08-14 14:35:30', 1, 33, 2000, 0, '', 4),
(41, NULL, 'Svéda Csaba', '', 2, '', '2024-08-14 14:35:30', 1, 33, 2000, 0, '', 4),
(42, NULL, 'Szász Barbara', '', 2, '', '2024-08-14 14:35:30', 1, 33, 2000, 0, '', 4),
(43, NULL, 'Szauer Dániel Mihály', '', 2, '', '2024-08-14 14:35:30', 1, 33, 2000, 0, '', 4),
(44, NULL, 'Tóbis Ede Mihály', '', 2, '', '2024-08-14 14:35:30', 1, 33, 2000, 0, '', 4),
(45, NULL, 'Toldi Zoltán', '', 2, '', '2024-08-14 14:35:30', 1, 33, 2000, 0, '', 4),
(46, NULL, 'Hable Tibor', '', 2, '', '2024-08-14 14:35:30', 1, 50, 2000, 0, '', 5),
(47, NULL, 'Hajdu László', '', 2, '', '2024-08-14 14:35:30', 1, 50, 2000, 0, '', 5),
(48, NULL, 'Hevesné Hoffmann Ágnes', '', 2, '', '2024-08-14 14:35:30', 1, 50, 2000, 0, '', 5),
(49, NULL, 'Huszár Zsófia Anita', '', 2, '', '2024-08-14 14:35:30', 1, 50, 2000, 0, '', 5),
(50, NULL, 'Weisz Attila', '', 2, '', '2024-08-14 14:35:30', 1, 50, 2000, 0, '', 5),
(52, 'c684573142a7ede538c1243aac62cb18', 'Minta user X', '73accb1ea98f9fb728e8f61190e05d3d', 2, 'c684573142a7ede538c1243aac62cb181723723095', '2024-08-15 13:51:05', 1, 1, 2000, 1, '', 0);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `user_job_titles`
--

CREATE TABLE `user_job_titles` (
  `jobCode` int(11) NOT NULL,
  `jobName` varchar(100) NOT NULL,
  `created` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- A tábla adatainak kiíratása `user_job_titles`
--

INSERT INTO `user_job_titles` (`jobCode`, `jobName`, `created`) VALUES
(1, 'Admin', '2024-07-04 12:36:27'),
(2, 'Guest', '2024-07-04 12:36:27');

--
-- Indexek a kiírt táblákhoz
--

--
-- A tábla indexei `locations`
--
ALTER TABLE `locations`
  ADD PRIMARY KEY (`id`);

--
-- A tábla indexei `register`
--
ALTER TABLE `register`
  ADD PRIMARY KEY (`id`);

--
-- A tábla indexei `register_closedmonths`
--
ALTER TABLE `register_closedmonths`
  ADD PRIMARY KEY (`id`);

--
-- A tábla indexei `register_logs`
--
ALTER TABLE `register_logs`
  ADD PRIMARY KEY (`id`);

--
-- A tábla indexei `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- A tábla indexei `user_job_titles`
--
ALTER TABLE `user_job_titles`
  ADD PRIMARY KEY (`jobCode`);

--
-- A kiírt táblák AUTO_INCREMENT értéke
--

--
-- AUTO_INCREMENT a táblához `locations`
--
ALTER TABLE `locations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT a táblához `register`
--
ALTER TABLE `register`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT a táblához `register_closedmonths`
--
ALTER TABLE `register_closedmonths`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT a táblához `register_logs`
--
ALTER TABLE `register_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;

--
-- AUTO_INCREMENT a táblához `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=53;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
