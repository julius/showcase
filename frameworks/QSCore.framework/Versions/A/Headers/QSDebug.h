/*
 *  QSDebug.h
 *  Quicksilver
 *
 *  Created by Alcor on 2/2/05.
 *  Copyright 2005 Blacktree. All rights reserved.
 *
 */

#define VERBOSE (int) getenv("verbose")
#define DEBUG (bool) getenv("NSDebugEnabled")

#define DEBUG_RANKING (int) getenv("QSDebugRanking")
#define DEBUG_MNEMONICS (int) getenv("QSDebugMnemonics")
#define DEBUG_PLUGINS (int) getenv("QSDebugPlugIns")
#define DEBUG_MEMORY (int) getenv("QSDebugMemory")
#define DEBUG_STARTUP (int) getenv("QSDebugStartup")
#define DEBUG_CATALOG (int) getenv("QSDebugCatalog")
