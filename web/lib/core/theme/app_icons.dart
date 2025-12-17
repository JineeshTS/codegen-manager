import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Application icons mapping using Lucide Icons.
/// DO NOT use icons from other packages.
class AppIcons {
  AppIcons._(); // Private constructor to prevent instantiation

  // ═══════════════════════════════════════════════════════════════
  // ICON SIZES
  // ═══════════════════════════════════════════════════════════════

  /// Small icon size (16px) - In buttons, inputs
  static const double iconSmall = 16.0;

  /// Medium icon size (20px) - Default
  static const double iconMedium = 20.0;

  /// Large icon size (24px) - Standalone icons
  static const double iconLarge = 24.0;

  /// Extra large icon size (32px) - Empty states, features
  static const double iconXLarge = 32.0;

  // ═══════════════════════════════════════════════════════════════
  // NAVIGATION ICONS
  // ═══════════════════════════════════════════════════════════════

  static const IconData home = LucideIcons.home;
  static const IconData back = LucideIcons.arrowLeft;
  static const IconData close = LucideIcons.x;
  static const IconData menu = LucideIcons.menu;
  static const IconData settings = LucideIcons.settings;

  // ═══════════════════════════════════════════════════════════════
  // ACTION ICONS
  // ═══════════════════════════════════════════════════════════════

  static const IconData add = LucideIcons.plus;
  static const IconData edit = LucideIcons.pencil;
  static const IconData delete = LucideIcons.trash2;
  static const IconData search = LucideIcons.search;
  static const IconData filter = LucideIcons.filter;
  static const IconData share = LucideIcons.share2;
  static const IconData refresh = LucideIcons.refreshCw;
  static const IconData download = LucideIcons.download;
  static const IconData upload = LucideIcons.upload;
  static const IconData save = LucideIcons.save;
  static const IconData copy = LucideIcons.copy;

  // ═══════════════════════════════════════════════════════════════
  // STATUS ICONS
  // ═══════════════════════════════════════════════════════════════

  static const IconData success = LucideIcons.checkCircle;
  static const IconData error = LucideIcons.alertCircle;
  static const IconData warning = LucideIcons.alertTriangle;
  static const IconData info = LucideIcons.info;
  static const IconData check = LucideIcons.check;

  // ═══════════════════════════════════════════════════════════════
  // USER ICONS
  // ═══════════════════════════════════════════════════════════════

  static const IconData user = LucideIcons.user;
  static const IconData login = LucideIcons.logIn;
  static const IconData logout = LucideIcons.logOut;
  static const IconData profile = LucideIcons.userCircle;

  // ═══════════════════════════════════════════════════════════════
  // FORM ICONS
  // ═══════════════════════════════════════════════════════════════

  static const IconData email = LucideIcons.mail;
  static const IconData password = LucideIcons.lock;
  static const IconData eyeOpen = LucideIcons.eye;
  static const IconData eyeClosed = LucideIcons.eyeOff;
  static const IconData calendar = LucideIcons.calendar;
  static const IconData clock = LucideIcons.clock;

  // ═══════════════════════════════════════════════════════════════
  // PROJECT & FILE ICONS
  // ═══════════════════════════════════════════════════════════════

  static const IconData folder = LucideIcons.folder;
  static const IconData file = LucideIcons.file;
  static const IconData code = LucideIcons.code;
  static const IconData fileText = LucideIcons.fileText;
  static const IconData github = LucideIcons.github;
  static const IconData gitBranch = LucideIcons.gitBranch;
  static const IconData gitCommit = LucideIcons.gitCommit;

  // ═══════════════════════════════════════════════════════════════
  // EXECUTION & TASK ICONS
  // ═══════════════════════════════════════════════════════════════

  static const IconData play = LucideIcons.play;
  static const IconData pause = LucideIcons.pause;
  static const IconData stop = LucideIcons.square;
  static const IconData skipForward = LucideIcons.skipForward;
  static const IconData fastForward = LucideIcons.fastForward;
  static const IconData loader = LucideIcons.loader;

  // ═══════════════════════════════════════════════════════════════
  // AI & REVIEW ICONS
  // ═══════════════════════════════════════════════════════════════

  static const IconData bot = LucideIcons.bot;
  static const IconData sparkles = LucideIcons.sparkles;
  static const IconData zap = LucideIcons.zap;
  static const IconData cpu = LucideIcons.cpu;

  // ═══════════════════════════════════════════════════════════════
  // DIRECTION ICONS
  // ═══════════════════════════════════════════════════════════════

  static const IconData arrowUp = LucideIcons.arrowUp;
  static const IconData arrowDown = LucideIcons.arrowDown;
  static const IconData arrowLeft = LucideIcons.arrowLeft;
  static const IconData arrowRight = LucideIcons.arrowRight;
  static const IconData chevronUp = LucideIcons.chevronUp;
  static const IconData chevronDown = LucideIcons.chevronDown;
  static const IconData chevronLeft = LucideIcons.chevronLeft;
  static const IconData chevronRight = LucideIcons.chevronRight;

  // ═══════════════════════════════════════════════════════════════
  // MISC ICONS
  // ═══════════════════════════════════════════════════════════════

  static const IconData moreVertical = LucideIcons.moreVertical;
  static const IconData moreHorizontal = LucideIcons.moreHorizontal;
  static const IconData list = LucideIcons.list;
  static const IconData grid = LucideIcons.grid;
  static const IconData help = LucideIcons.helpCircle;
  static const IconData external = LucideIcons.externalLink;
  static const IconData link = LucideIcons.link;
  static const IconData unlink = LucideIcons.unlink;
}
