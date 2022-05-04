/*
 * technicabr.h
 *
 *  Created on: Oct 5, 2017
 *      Author: ecos
 */

#ifndef INCLUDE_TECHNICABR_H_
#define INCLUDE_TECHNICABR_H_

#include <linux/sockios.h>

#define SIOCBASET1 (SIOCDEVPRIVATE)

#define SIOCBASET1_FLAGS_MASTER (1<<0)
#define SIOCBASET1_FLAGS_SLAVE (1<<1)
#define SIOCBASET1_FLAGS_AUTONEG_MASTER_SLAVE (SIOCBASET1_FLAGS_MASTER | SIOCBASET1_FLAGS_SLAVE)

#endif /* INCLUDE_TECHNICABR_H_ */
