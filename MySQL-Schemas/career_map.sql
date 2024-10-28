-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 28, 2024 at 07:19 AM
-- Server version: 10.4.24-MariaDB
-- PHP Version: 8.1.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `career_map`
--

-- --------------------------------------------------------

--
-- Table structure for table `action_plan_summary`
--

CREATE TABLE `action_plan_summary` (
  `id` bigint(20) NOT NULL,
  `action` varchar(255) NOT NULL,
  `responsiblity` enum('self','mentor','self/mentor') NOT NULL,
  `plan_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `branch`
--

CREATE TABLE `branch` (
  `id` bigint(20) NOT NULL,
  `step_id` bigint(20) DEFAULT NULL,
  `color` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `path_id` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `career_goals_overview`
--

CREATE TABLE `career_goals_overview` (
  `id` bigint(20) NOT NULL,
  `plan_id` bigint(20) NOT NULL,
  `title` text NOT NULL,
  `type` enum('s','l') NOT NULL,
  `completion_date` date NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `career_path_progression_map`
--

CREATE TABLE `career_path_progression_map` (
  `id` bigint(20) NOT NULL,
  `plan_id` bigint(20) NOT NULL,
  `role` varchar(255) NOT NULL,
  `suggested_timing` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `facebook_login`
--

CREATE TABLE `facebook_login` (
  `id` int(11) NOT NULL,
  `facebook_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `profile_picture` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `google_login`
--

CREATE TABLE `google_login` (
  `id` int(11) NOT NULL,
  `google_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `profile_picture` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `google_login`
--

INSERT INTO `google_login` (`id`, `google_id`, `email`, `name`, `profile_picture`, `created_at`, `updated_at`) VALUES
(4, '109075669814140893830', 'pycess76x@gmail.com', 'Talha Hussain', 'https://lh3.googleusercontent.com/a/ACg8ocIa9k1DVtuum9RBvO7yaYjcaUZX_ev4cXOl8ZxFOR8fZ9nnBA=s96-c', '2024-08-08 11:14:20', '2024-08-08 11:14:20'),
(5, '110076916993612126119', 'pc16777.syedtalhahussain@gmail.com', 'Syed Talha Hussain', 'https://lh3.googleusercontent.com/a/ACg8ocJtV42Mo0Nk89nzEzcKovoOy8Ew1iCB7WPeu9EZHvJ9ZmowSw=s96-c', '2024-08-12 08:23:09', '2024-08-13 11:17:13'),
(8, '116605168680275671000', 'syedtalha71x@gmail.com', 'Talha', 'https://lh3.googleusercontent.com/a/ACg8ocI0Uc1DRZWyA28sY-Byf-q1MEw_4kAkUp_6eGDY9R3-FlAGXw=s96-c', '2024-08-22 09:43:07', '2024-08-22 09:43:07');

-- --------------------------------------------------------

--
-- Table structure for table `instagram_login`
--

CREATE TABLE `instagram_login` (
  `id` int(11) NOT NULL,
  `instagram_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `profile_picture` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `linkedin_login`
--

CREATE TABLE `linkedin_login` (
  `id` int(11) NOT NULL,
  `linkedin_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `profile_picture` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `model_subscription`
--

CREATE TABLE `model_subscription` (
  `id` bigint(20) NOT NULL,
  `user_id` int(11) NOT NULL,
  `subscription_id` int(11) NOT NULL,
  `payment_id` bigint(255) DEFAULT NULL,
  `branch_id` int(11) NOT NULL,
  `amount` int(20) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `modules`
--

CREATE TABLE `modules` (
  `id` int(11) NOT NULL,
  `module_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `modules`
--

INSERT INTO `modules` (`id`, `module_name`) VALUES
(1, 'Transaction'),
(6, 'Pricing'),
(7, 'Subscription');

-- --------------------------------------------------------

--
-- Table structure for table `next_steps_recommendations`
--

CREATE TABLE `next_steps_recommendations` (
  `id` bigint(20) NOT NULL,
  `plan_id` bigint(20) NOT NULL,
  `recommendations` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `title` varchar(350) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(350) COLLATE utf8mb4_unicode_ci NOT NULL,
  `link` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `read` tinyint(4) NOT NULL DEFAULT 0,
  `seen` tinyint(4) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`id`, `user_id`, `title`, `description`, `link`, `read`, `seen`) VALUES
(3, 30, 'System Maintenance Scheduled', 'Our system will be undergoing maintenance on October 1st at 10:00 PM.', 'https://www.google.com/', 1, 1),
(4, 30, 'Database Admin Scheduled', 'Our database admin system will be undergoing maintenance on September 1st at 8:00 PM.', 'https://www.google.com/', 1, 1),
(5, 30, 'I am an infrastructure Specialist', 'This path has been analyse', NULL, 1, 1),
(6, 30, 'react js developer', 'This path has been analyse', NULL, 1, 1),
(7, 30, 'react js developer', 'This path has been analyse', NULL, 0, 0),
(8, 36, 'Law grad to solicitor', 'This path has been analyse', NULL, 1, 1),
(9, 36, 'Pipefitter to superintendant ', 'This path has been analyse', NULL, 1, 1),
(10, 36, 'Law ', 'This path has been analyse', NULL, 1, 1),
(11, 36, 'law 2', 'This path has been analyse', NULL, 1, 1),
(12, 28, 'javascript', 'This path has been analyse', NULL, 1, 1),
(13, 30, 'Law grad to solicitor', 'This path has been analyse', NULL, 0, 0),
(14, 30, 'Pipefitter to superintendant ', 'This path has been analyse', NULL, 0, 0),
(15, 30, 'Law ', 'This path has been analyse', NULL, 0, 0),
(16, 30, 'law 2', 'This path has been analyse', NULL, 0, 0),
(17, 30, 'javascript', 'This path has been analyse', NULL, 0, 0),
(18, 36, 'IT Specialist Career', 'This path has been analyse', NULL, 0, 1),
(19, 37, 'javascript', 'This path has been analyse', NULL, 1, 1),
(20, 37, 'python developer', 'This path has been analyse', NULL, 1, 1),
(21, 37, 'data entry', 'This path has been analyse', NULL, 1, 1),
(22, 37, 'data entry operator', 'This path has been analyse', NULL, 1, 1),
(23, 28, 'frontend developer', 'This path has been analyse', NULL, 1, 1),
(24, 37, 'ml engineer', 'This path has been analyse', NULL, 1, 1),
(25, 37, ' Machine learning developer', 'This path has been analyse', NULL, 1, 1),
(26, 37, 'react js developer', 'This path has been analyse', NULL, 1, 1),
(27, 37, 'react js developer', 'This path has been analyse', NULL, 1, 1),
(28, 37, 'ai engineer', 'This path has been analyse', NULL, 1, 1),
(29, 37, 'data entry operator', 'This path has been analyse', NULL, 1, 1),
(30, 37, ' python developer', 'This path has been analyse', NULL, 1, 1),
(31, 37, ' python developer', 'This path has been analyse', NULL, 1, 1),
(32, 37, ' python developer', 'This path has been analyse', NULL, 1, 1),
(33, 37, 'python developer', 'This path has been analyse', NULL, 1, 1),
(34, 37, ' python developer', 'This path has been analyse', NULL, 1, 1),
(35, 37, 'mechanic ', 'This path has been analyse', NULL, 1, 1),
(36, 37, 'blockchain developer', 'This path has been analyse', NULL, 1, 1),
(37, 37, 'blockchain with Ai developer', 'This path has been analyse', NULL, 1, 1),
(38, 37, ' python developer', 'This path has been analyse', NULL, 1, 1),
(39, 37, ' python developer', 'This path has been analyse', NULL, 1, 1),
(40, 37, 'blockchain with Ai developer', 'This path has been analyse', NULL, 1, 1),
(41, 37, 'mechanic ', 'This path has been analyse', NULL, 1, 1),
(42, 37, 'react js developer', 'This path has been analyse', NULL, 1, 1),
(43, 37, 'data entry operator', 'This path has been analyse', NULL, 1, 1),
(44, 37, 'ai engineer', 'This path has been analyse', NULL, 1, 1),
(45, 37, 'data entry operator', 'This path has been analyse', NULL, 1, 1),
(46, 37, 'singer', 'This path has been analyse', NULL, 0, 1),
(47, 37, 'python developer banna hy mujhe', 'This path has been analyse', NULL, 0, 1),
(48, 37, 'python developer banna hy mujhe', 'This path has been analyse', NULL, 0, 1),
(49, 37, 'javascript deveoper', 'This path has been analyse', NULL, 0, 1),
(50, 37, 'ml engineer', 'This path has been analyse', NULL, 0, 1),
(51, 37, 'javascript deveoper', 'This path has been analyse', NULL, 0, 1),
(52, 28, 'python developer', 'This path has been analyse', NULL, 1, 1),
(53, 28, 'python developer', 'This path has been analyse', NULL, 1, 1),
(54, 28, 'python developer', 'This path has been analyse', NULL, 1, 1),
(55, 28, 'singer', 'This path has been analyse', NULL, 0, 0),
(56, 28, 'ai engineer', 'This path has been analyse', NULL, 0, 0),
(57, 28, 'frontend developer', 'This path has been analyse', NULL, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `outlook_login`
--

CREATE TABLE `outlook_login` (
  `id` int(11) NOT NULL,
  `outlook_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `profile_picture` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `path`
--

CREATE TABLE `path` (
  `id` bigint(20) NOT NULL,
  `prompt` longtext COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `file` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('pending','analysed','analysing') COLLATE utf8mb4_unicode_ci DEFAULT 'pending',
  `user_id` int(11) DEFAULT NULL,
  `title` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `gpt_id` varchar(350) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `permissions`
--

CREATE TABLE `permissions` (
  `id` int(11) NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `slug` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `permissions`
--

INSERT INTO `permissions` (`id`, `name`, `created_at`, `updated_at`, `slug`) VALUES
(4, 'index', '2024-09-19 07:50:57', '2024-09-19 08:00:13', 'transaction-index'),
(5, 'create', '2024-09-19 07:50:57', '2024-09-19 07:50:57', 'transaction-create'),
(6, 'update', '2024-09-19 07:50:57', '2024-09-19 07:50:57', 'transaction-update'),
(13, 'index', '2024-09-19 11:27:53', '2024-09-19 11:27:53', 'pricing-index'),
(14, 'createIndex', '2024-09-19 11:29:12', '2024-09-19 11:29:12', 'subscription-create-index'),
(15, 'viewIndex', '2024-09-19 11:29:12', '2024-09-19 11:29:12', 'subscription-view-index');

-- --------------------------------------------------------

--
-- Table structure for table `permission_modules`
--

CREATE TABLE `permission_modules` (
  `permission_id` int(11) DEFAULT NULL,
  `module_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `permission_modules`
--

INSERT INTO `permission_modules` (`permission_id`, `module_id`) VALUES
(13, 6),
(14, 7),
(15, 7);

-- --------------------------------------------------------

--
-- Table structure for table `permission_to_role`
--

CREATE TABLE `permission_to_role` (
  `id` int(11) NOT NULL,
  `role_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `permission_to_role`
--

INSERT INTO `permission_to_role` (`id`, `role_id`, `permission_id`, `created_at`, `updated_at`) VALUES
(6, 2, 4, '2024-09-19 08:09:57', '2024-09-19 08:09:57'),
(7, 2, 5, '2024-09-19 08:09:57', '2024-09-19 08:09:57');

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `id` int(11) NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `name`, `created_at`, `updated_at`) VALUES
(1, 'admin', '2024-09-19 07:29:05', '2024-09-19 07:39:58'),
(2, 'sub user', '2024-09-19 08:04:12', '2024-09-19 08:04:12');

-- --------------------------------------------------------

--
-- Table structure for table `role_to_users`
--

CREATE TABLE `role_to_users` (
  `role_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `role_to_users`
--

INSERT INTO `role_to_users` (`role_id`, `user_id`) VALUES
(1, 30),
(2, 35);

-- --------------------------------------------------------

--
-- Table structure for table `skills`
--

CREATE TABLE `skills` (
  `id` bigint(20) NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sort` tinyint(1) NOT NULL,
  `step_id` bigint(20) DEFAULT NULL,
  `status` enum('pending','completed') COLLATE utf8mb4_unicode_ci DEFAULT 'pending'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `skill_gap_analysis`
--

CREATE TABLE `skill_gap_analysis` (
  `id` bigint(20) NOT NULL,
  `plan_id` bigint(20) NOT NULL,
  `title` text NOT NULL,
  `priority` enum('High','Medium','Low') DEFAULT NULL,
  `status` enum('pending','completed') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `skill_gap_analysis_resources`
--

CREATE TABLE `skill_gap_analysis_resources` (
  `id` bigint(20) NOT NULL,
  `skill_gap_analysis_id` bigint(20) NOT NULL,
  `title` varchar(255) NOT NULL,
  `platform` varchar(255) NOT NULL,
  `link` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `steps`
--

CREATE TABLE `steps` (
  `id` bigint(20) NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sort` tinyint(4) NOT NULL,
  `path_id` bigint(20) DEFAULT NULL,
  `status` enum('pending','completed') COLLATE utf8mb4_unicode_ci DEFAULT 'pending',
  `branch_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `subscriptions`
--

CREATE TABLE `subscriptions` (
  `id` int(11) NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `valid_till` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `subscriptions`
--

INSERT INTO `subscriptions` (`id`, `name`, `price`, `valid_till`) VALUES
(8, 'Gold Plan', '20.99', 10),
(9, 'Platnium Plan', '20.99', 10),
(10, 'Bronze Plan', '13.22', 20);

-- --------------------------------------------------------

--
-- Table structure for table `training_activities`
--

CREATE TABLE `training_activities` (
  `id` bigint(20) NOT NULL,
  `plan_id` bigint(20) NOT NULL,
  `title` varchar(255) NOT NULL,
  `expected_outcomes` text NOT NULL,
  `progress_measurement` varchar(255) NOT NULL,
  `duration` varchar(255) NOT NULL,
  `date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `responsible` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `trainning_plan`
--

CREATE TABLE `trainning_plan` (
  `id` bigint(20) NOT NULL,
  `plan_recommendation` text NOT NULL,
  `branch_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `profile_picture` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `otp` varchar(6) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `otp_expiration` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `email`, `password`, `profile_picture`, `otp`, `otp_expiration`) VALUES
(1, 'hussain21x', 'hussain12@gmail.com', '8b117546c9cdd79b2f88159fd94e1195623f7f8b53b54a2bb3b7675ecd834a93', NULL, NULL, NULL),
(2, 'faris21x', 'faris12@gmail.com', '8a91dbf39a7d58400d17676648461e8d9895a7a48ea02e6a641de439b402a656', NULL, NULL, NULL),
(3, 'talha17x', 'talha@gmail.com', '866d9540979b7e1b9686517bae7308eef0cb7c5217a3f49d5a0132190595b232', NULL, NULL, NULL),
(4, 'aiman12', 'aiman@gmail.com', '1a62b2b12c469335995cced03433260373e0b975344059e1a1fbdc66e6aca914', NULL, NULL, NULL),
(5, 'haris12', 'haris12@gmail.com', 'cffd26c9ddbb65b048a0f714b704a5ed9a5ad7a66130b7a43963899528a97928', NULL, NULL, NULL),
(6, 'test1', 'test12@gmail.com', 'c42bd77fb632be76f683bc427943fb3f848170dc33c14b7d5dc1b771db078c84', NULL, NULL, NULL),
(7, 'one71x', 'one@gmail.com', '4d312d42968237ea5e754e39580b0f7fbb906dbf8608847310df370ed45828dd', NULL, NULL, NULL),
(8, 'syed71x', 'syed@gmail.com', '73f72fcd6f1108782be74a62f817922edfc021a5d6a68513ec8aa9af4fad3b45', NULL, NULL, NULL),
(9, 'mustafa69x', 'mustafa@gmail.com', '8e352b24effd2b624844f3d5d0fb2a0960903bf8aee759c2226a98993329c702', NULL, NULL, NULL),
(10, 'shayan71x', 'shayan@gmail.com', '506c78e44f2184e46a6467bb17cf6b5937821be63a6170a8b8a07331b1660e13', NULL, NULL, NULL),
(11, 'Two69x$', 'two@gmail.com', '2e1d7dfa4ca32532c7d453db04da86afcf38f0cc4008e1f577854b32c51115a7', 'https://images.pexels.com/photos/2310713/pexels-photo-2310713.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500', NULL, NULL),
(13, 'hunain69x', 'hunain@gmail.com', '840dc021cf333401c6b8f854939c7065058c6468843a37610071ded8569902b6', NULL, NULL, NULL),
(14, 'three12', 'three12@gmail.com', 'b7af263584bc6e827fa262dd8eb99d8bb3b1b43d045d3643acc8d975e49d30a3', NULL, NULL, NULL),
(15, 'hassan', 'hassan123@gmail.com', '5c80b9535206b56dc8d78543de507d3e3fe08636dc6a9d12deb1dac0e7e5bb87', NULL, 'gQXel3', '2024-08-19 14:40:39'),
(19, 'poka123', 'poka123@gmail.com', '22306f9ad37b7be1e823c6a1ccbc2cb944e6c9962f8f9da5103dc3f70b622c77', NULL, NULL, NULL),
(21, 'anas71x', 'anas@gmail.com', '5410327224be6b772e71705ef1c6e8f87d8d253754c56f1521f642cef16b3898', NULL, NULL, NULL),
(22, 'areeba12', 'areeba@gmail.com', '8d080c78cd9eb424ad93536b6b4faf3e521661a1bab4068cdc5e902ac623651f', NULL, NULL, NULL),
(23, 'tassaract', 'tassaract@gmail.com', 'e07c1b21783643c0a9b33e3e80fe7f275a4ea3c20b0c00b910fc91f6177e3039', NULL, NULL, NULL),
(24, 'tassaract1', 'tassaract1@gmail.com', 'e07c1b21783643c0a9b33e3e80fe7f275a4ea3c20b0c00b910fc91f6177e3039', NULL, NULL, NULL),
(27, 'ahmed', 'ahmed@gmail.com', '77a2e452cc950bddfa44fe8c61db107305166800b489adf97f31fad9e2ba72f6', NULL, NULL, NULL),
(28, 'hassan123', 'hassanalirajput2004@gmail.com', 'f24189059d64afc71e47e8f5aa90714023773477ee6bdacb15337148a6932acd', NULL, 'puVzLQ', '2024-10-08 13:13:09'),
(29, 'talha_83x', 'pc16777.syedtalhahussain@gmail.com', '866d9540979b7e1b9686517bae7308eef0cb7c5217a3f49d5a0132190595b232', NULL, NULL, NULL),
(30, 'syed899x', 'syedtalha71x@gmail.com', 'ea045594007793a45a9d9a22d3dea1416603ad40bcb9fa0fae570e4cfdf5acd4', NULL, NULL, NULL),
(31, 'amna', 'amna@gmail.com', 'a24738c27f7a51a6079b03d7149a5c12e4608a356c4d17e316b71941d819c346', NULL, NULL, NULL),
(32, 'noor', 'noor@gmail.com', '6913c81ff94fc68e7b04d1de8b226fcd528fcb3c939cacce6bb5859c7a6157b4', NULL, NULL, NULL),
(33, 'faizan_18x', 'faizan@gmail.com', '49f606bc2b2239194f22b0f301ff6aec2860e636f5eed176e308f6fd2c55fcde', NULL, NULL, NULL),
(34, 'khan', 'khan@gmail.com', 'cad3fe7aae4d46b047d0164e64aed2b1a98b74bf45d0fc23be076005504bace6', NULL, NULL, NULL),
(35, 'hadi', 'hadi@gmail.com', 'b87622c28e68762bc12fd2e4fddc2daae09a09679d54b4e8d4de7814ec8207c4', NULL, NULL, NULL),
(36, 'Alroylewis', 'Alroylewis@hotmail.co.uk', 'f95a6ba11d2cdcfcf9a073ea603492139bd05f71709af61b73dc4594f3f4866d', NULL, NULL, NULL),
(37, 'hassan321', 'unitedfurniture75@gmail.com', 'f24189059d64afc71e47e8f5aa90714023773477ee6bdacb15337148a6932acd', NULL, NULL, NULL),
(38, 'zaidworks515', 'zaid_works515@outlook.com', 'd4598a2752541ac5de8ebc3b1923b57f9052ede3f40ae572957b5fe9b984cb83', NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `user_subscription`
--

CREATE TABLE `user_subscription` (
  `id` int(11) NOT NULL,
  `subscription_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `expiry_date` datetime NOT NULL,
  `payment_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user_subscription`
--

INSERT INTO `user_subscription` (`id`, `subscription_id`, `user_id`, `expiry_date`, `payment_id`, `created_at`, `updated_at`) VALUES
(9, 8, 30, '2024-08-30 00:00:00', 'pi_3PprfnIILuhliL1z00EGL4bm', '2024-08-20 13:00:35', '2024-08-20 13:00:35'),
(11, 10, 29, '2024-09-10 00:00:00', 'pi_3Pq8dfIILuhliL1z1pFtpte9', '2024-08-21 07:07:31', '2024-08-21 07:07:31'),
(13, 10, 29, '2024-09-10 00:00:00', 'pi_3PqEplIILuhliL1z0hxEU6sZ', '2024-08-21 13:44:24', '2024-08-21 13:44:24'),
(14, 10, 29, '2024-09-10 00:00:00', 'pi_3PqEplIILuhliL1z0hxEU6sZ', '2024-08-21 13:44:24', '2024-08-21 13:44:24');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `action_plan_summary`
--
ALTER TABLE `action_plan_summary`
  ADD PRIMARY KEY (`id`),
  ADD KEY `plan_id` (`plan_id`);

--
-- Indexes for table `branch`
--
ALTER TABLE `branch`
  ADD PRIMARY KEY (`id`),
  ADD KEY `path_id` (`step_id`),
  ADD KEY `fk_branch_path_id` (`path_id`);

--
-- Indexes for table `career_goals_overview`
--
ALTER TABLE `career_goals_overview`
  ADD PRIMARY KEY (`id`),
  ADD KEY `plan_id` (`plan_id`);

--
-- Indexes for table `career_path_progression_map`
--
ALTER TABLE `career_path_progression_map`
  ADD PRIMARY KEY (`id`),
  ADD KEY `plan_id` (`plan_id`);

--
-- Indexes for table `facebook_login`
--
ALTER TABLE `facebook_login`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `facebook_id` (`facebook_id`);

--
-- Indexes for table `google_login`
--
ALTER TABLE `google_login`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `google_id` (`google_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `instagram_login`
--
ALTER TABLE `instagram_login`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `instagram_id` (`instagram_id`);

--
-- Indexes for table `linkedin_login`
--
ALTER TABLE `linkedin_login`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `linkedin_id` (`linkedin_id`);

--
-- Indexes for table `model_subscription`
--
ALTER TABLE `model_subscription`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `modules`
--
ALTER TABLE `modules`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `next_steps_recommendations`
--
ALTER TABLE `next_steps_recommendations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `plan_id` (`plan_id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `outlook_login`
--
ALTER TABLE `outlook_login`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `outlook_id` (`outlook_id`);

--
-- Indexes for table `path`
--
ALTER TABLE `path`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `permissions`
--
ALTER TABLE `permissions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `permission_modules`
--
ALTER TABLE `permission_modules`
  ADD KEY `permission_id` (`permission_id`),
  ADD KEY `module_id` (`module_id`);

--
-- Indexes for table `permission_to_role`
--
ALTER TABLE `permission_to_role`
  ADD PRIMARY KEY (`id`),
  ADD KEY `role_id` (`role_id`),
  ADD KEY `permission_id` (`permission_id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `role_to_users`
--
ALTER TABLE `role_to_users`
  ADD KEY `role_id` (`role_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `skills`
--
ALTER TABLE `skills`
  ADD PRIMARY KEY (`id`),
  ADD KEY `step_id` (`step_id`);

--
-- Indexes for table `skill_gap_analysis`
--
ALTER TABLE `skill_gap_analysis`
  ADD PRIMARY KEY (`id`),
  ADD KEY `plan_id` (`plan_id`);

--
-- Indexes for table `skill_gap_analysis_resources`
--
ALTER TABLE `skill_gap_analysis_resources`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `steps`
--
ALTER TABLE `steps`
  ADD PRIMARY KEY (`id`),
  ADD KEY `path_id` (`path_id`),
  ADD KEY `fk_steps_branch_id` (`branch_id`);

--
-- Indexes for table `subscriptions`
--
ALTER TABLE `subscriptions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `training_activities`
--
ALTER TABLE `training_activities`
  ADD PRIMARY KEY (`id`),
  ADD KEY `plan_id` (`plan_id`);

--
-- Indexes for table `trainning_plan`
--
ALTER TABLE `trainning_plan`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `user_subscription`
--
ALTER TABLE `user_subscription`
  ADD PRIMARY KEY (`id`),
  ADD KEY `subscription_id` (`subscription_id`),
  ADD KEY `user_id` (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `action_plan_summary`
--
ALTER TABLE `action_plan_summary`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `branch`
--
ALTER TABLE `branch`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `career_goals_overview`
--
ALTER TABLE `career_goals_overview`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `career_path_progression_map`
--
ALTER TABLE `career_path_progression_map`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `facebook_login`
--
ALTER TABLE `facebook_login`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `google_login`
--
ALTER TABLE `google_login`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `instagram_login`
--
ALTER TABLE `instagram_login`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `linkedin_login`
--
ALTER TABLE `linkedin_login`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `model_subscription`
--
ALTER TABLE `model_subscription`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `modules`
--
ALTER TABLE `modules`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `next_steps_recommendations`
--
ALTER TABLE `next_steps_recommendations`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=58;

--
-- AUTO_INCREMENT for table `outlook_login`
--
ALTER TABLE `outlook_login`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `path`
--
ALTER TABLE `path`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `permissions`
--
ALTER TABLE `permissions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `permission_to_role`
--
ALTER TABLE `permission_to_role`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `skills`
--
ALTER TABLE `skills`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `skill_gap_analysis`
--
ALTER TABLE `skill_gap_analysis`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `skill_gap_analysis_resources`
--
ALTER TABLE `skill_gap_analysis_resources`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `steps`
--
ALTER TABLE `steps`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `subscriptions`
--
ALTER TABLE `subscriptions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `training_activities`
--
ALTER TABLE `training_activities`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `trainning_plan`
--
ALTER TABLE `trainning_plan`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

--
-- AUTO_INCREMENT for table `user_subscription`
--
ALTER TABLE `user_subscription`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `action_plan_summary`
--
ALTER TABLE `action_plan_summary`
  ADD CONSTRAINT `action_plan_summary_ibfk_1` FOREIGN KEY (`plan_id`) REFERENCES `trainning_plan` (`id`);

--
-- Constraints for table `branch`
--
ALTER TABLE `branch`
  ADD CONSTRAINT `fk_branch_path_id` FOREIGN KEY (`path_id`) REFERENCES `path` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_branch_step_id` FOREIGN KEY (`step_id`) REFERENCES `steps` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `career_goals_overview`
--
ALTER TABLE `career_goals_overview`
  ADD CONSTRAINT `career_goals_overview_ibfk_1` FOREIGN KEY (`plan_id`) REFERENCES `trainning_plan` (`id`);

--
-- Constraints for table `career_path_progression_map`
--
ALTER TABLE `career_path_progression_map`
  ADD CONSTRAINT `career_path_progression_map_ibfk_1` FOREIGN KEY (`plan_id`) REFERENCES `trainning_plan` (`id`);

--
-- Constraints for table `next_steps_recommendations`
--
ALTER TABLE `next_steps_recommendations`
  ADD CONSTRAINT `next_steps_recommendations_ibfk_1` FOREIGN KEY (`plan_id`) REFERENCES `trainning_plan` (`id`);

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `path`
--
ALTER TABLE `path`
  ADD CONSTRAINT `path_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `permission_modules`
--
ALTER TABLE `permission_modules`
  ADD CONSTRAINT `permission_modules_ibfk_1` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`),
  ADD CONSTRAINT `permission_modules_ibfk_2` FOREIGN KEY (`module_id`) REFERENCES `modules` (`id`);

--
-- Constraints for table `permission_to_role`
--
ALTER TABLE `permission_to_role`
  ADD CONSTRAINT `permission_to_role_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `permission_to_role_ibfk_2` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `role_to_users`
--
ALTER TABLE `role_to_users`
  ADD CONSTRAINT `role_to_users_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`),
  ADD CONSTRAINT `role_to_users_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `skills`
--
ALTER TABLE `skills`
  ADD CONSTRAINT `skills_ibfk_1` FOREIGN KEY (`step_id`) REFERENCES `steps` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `skill_gap_analysis`
--
ALTER TABLE `skill_gap_analysis`
  ADD CONSTRAINT `skill_gap_analysis_ibfk_1` FOREIGN KEY (`plan_id`) REFERENCES `trainning_plan` (`id`);

--
-- Constraints for table `steps`
--
ALTER TABLE `steps`
  ADD CONSTRAINT `fk_path_id` FOREIGN KEY (`path_id`) REFERENCES `path` (`id`),
  ADD CONSTRAINT `fk_steps_branch_id` FOREIGN KEY (`branch_id`) REFERENCES `branch` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `steps_ibfk_1` FOREIGN KEY (`path_id`) REFERENCES `path` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `training_activities`
--
ALTER TABLE `training_activities`
  ADD CONSTRAINT `training_activities_ibfk_1` FOREIGN KEY (`plan_id`) REFERENCES `trainning_plan` (`id`);

--
-- Constraints for table `user_subscription`
--
ALTER TABLE `user_subscription`
  ADD CONSTRAINT `user_subscription_ibfk_1` FOREIGN KEY (`subscription_id`) REFERENCES `subscriptions` (`id`),
  ADD CONSTRAINT `user_subscription_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
