<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to "wp-config.php" and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://wordpress.org/support/article/editing-wp-config-php/
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
//define( 'DB_NAME', 'wordpress' );

/** MySQL database username */
//define( 'DB_USER', 'wordpress1' );

/** MySQL database password */
//define( 'DB_PASSWORD', 'wordpress-pass' );

/** MySQL hostname */
//define( 'DB_HOST', 'terraform-20210719155332995200000001.ch1xci4kho1q.us-east-1.rds.amazonaws.com' );
define( 'DB_NAME', '${db_name}' );

/** MySQL database username */
define( 'DB_USER', '${db_user}' );

/** MySQL database password */
define( 'DB_PASSWORD', '${db_pass}' );

/** MySQL hostname */
define( 'DB_HOST', '${db_host}' );

/** Database Charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The Database Collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         '/KR(#-J{r+Nz|0A[+rc|+6AR*2&coAi(XH_4wN?Bk,o&&J8Ds1grc+f$I(b2R<E]');
define('SECURE_AUTH_KEY',  't;UPl1%Xn)dAMV^2&)*{SX3GHB_bAHQ^rf09#% <8ce[RP%M/SpcOCogS*uAy+9e');
define('LOGGED_IN_KEY',    'D>5=CkO8-.vmf[8EkTEPh@(r?Zv)4|j+Ch.QT8EwH-Ycb||/gyOtQlqjs31b@oi]');
define('NONCE_KEY',        'ek&y$1[JVbXf{,&{BSJ6(z~8Ow>9kn1U:l*jL1i>{N]}Aa2_{`l2d,_,:nmA|iPp');
define('AUTH_SALT',        ':kZ=b v)CFmdXbm,-X6F#h-qp*qn/-;J[M,vG3Y/a6=er!Q[Km#4I+[D.Wl=~/?F');
define('SECURE_AUTH_SALT', 'AF<n`PPk:pG1tVYxosq+aHbanE7-[J(h@WJ1hzqdC>BmVOf1JBX-e8,s*}pgp<$@');
define('LOGGED_IN_SALT',   'cwd{?69M:MQtyAwlQ7&4v2b#ni|&*W{zfK!/-W]nA18G0@(BN=4Is~&- P:T;vK`');
define('NONCE_SALT',       'd,62<|>;O]h;J5$|:_4(Q#xjU6fVU6/kUlsM%Kd(@&4xg.`uI!0~H-!>^i!bJJ%}');
/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://wordpress.org/support/article/debugging-in-wordpress/
 */
define( 'WP_DEBUG', false );

/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
