// Firefox user preferences
// This file overrides prefs.js settings
// Changes take effect after Firefox restart

// Session & Startup
user_pref("browser.startup.page", 3); // Restore previous session

// UI/UX
user_pref("browser.ctrlTab.sortByRecentlyUsed", true); // Ctrl+Tab by recent use
user_pref("browser.toolbars.bookmarks.visibility", "always"); // Always show bookmarks toolbar

// Privacy
user_pref("browser.contentblocking.category", "custom"); // Custom content blocking
user_pref("privacy.userContext.enabled", true); // Enable container tabs
user_pref("privacy.userContext.ui.enabled", true); // Show container tabs UI

// Advanced
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true); // Enable userChrome.css
