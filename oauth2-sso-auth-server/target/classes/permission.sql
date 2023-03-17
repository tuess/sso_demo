/*
 Navicat MySQL Data Transfer

 Source Server         : 本地
 Source Server Type    : MySQL
 Source Server Version : 50725
 Source Host           : localhost:3306
 Source Schema         : permission

 Target Server Type    : MySQL
 Target Server Version : 50725
 File Encoding         : 65001

 Date: 07/04/2019 17:51:35
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for oauth_client_details
-- ----------------------------
DROP TABLE IF EXISTS `oauth_client_details`;
CREATE TABLE `oauth_client_details`  (
    `client_id` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '	主键,必须唯一,不能为空.\r\n用于唯一标识每一个客户端(client); 在注册时必须填写(也可由服务端自动生成).\r\n对于不同的grant_type,该字段都是必须的. 在实际应用中的另一个名称叫appKey,与client_id是同一个概念.',
    `resource_ids` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '客户端所能访问的资源id集合,多个资源时用逗号(,)分隔,如: \"unity-resource,mobile-resource\".\n\n可以根据上图知道，我们有Resource Server资源服务器。，资源服务器可以有多个，我们可以为每一个Resource Server（一个微服务实例）设置一个resourceid。\n\nAuthorization Server给client第三方客户端授权的时候，可以设置这个client可以访问哪一些Resource Server资源服务，如果没设置，就是对所有的Resource Server都有访问权限。',
    `client_secret` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用于指定客户端(client)的访问密匙; 在注册时必须填写(也可由服务端自动生成).\r\n对于不同的grant_type,该字段都是必须的. 在实际应用中的另一个名称叫appSecret,与client_secret是同一个概念.',
    `scope` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '指定客户端申请的权限范围,可选值包括read,write,trust;若有多个权限范围用逗号(,)分隔,如: \"read,write\".\n\n@EnableGlobalMethodSecurity(prePostEnabled = true)启用方法级权限控制\n\n然后在方法上注解标识@PreAuthorize(\"#oauth2.hasScope(\'read\')\")',
    `authorized_grant_types` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '指定客户端支持的grant_type,可选值包括authorization_code,password,refresh_token,implicit,client_credentials, 若支持多个grant_type用逗号(,)分隔,如: \"authorization_code,password\".\n在实际应用中,当注册时,该字段是一般由服务器端指定的,而不是由申请者去选择的,最常用的grant_type组合有: \"authorization_code,refresh_token\"(针对通过浏览器访问的客户端); \"password,refresh_token\"(针对移动设备的客户端).\nimplicit与client_credentials在实际中很少使用，可以根据自己的需要，在OAuth2.0 提供的地方进行扩展自定义的授权',
    `web_server_redirect_uri` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '客户端的重定向URI,可为空, 当grant_type为authorization_code或implicit时, 在Oauth的流程中会使用并检查与注册时填写的redirect_uri是否一致. 下面分别说明:\n当grant_type=authorization_code时, 第一步 从 spring-oauth-server获取 \'code\'时客户端发起请求时必须有redirect_uri参数, 该参数的值必须与 web_server_redirect_uri的值一致. 第二步 用 \'code\' 换取 \'access_token\' 时客户也必须传递相同的redirect_uri.\n在实际应用中, web_server_redirect_uri在注册时是必须填写的, 一般用来处理服务器返回的code, 验证state是否合法与通过code去换取access_token值.\n在spring-oauth-client项目中, 可具体参考AuthorizationCodeController.java中的authorizationCodeCallback方法.\n当grant_type=implicit时通过redirect_uri的hash值来传递access_token值.如:\nhttp://localhost:7777/spring-oauth-client/implicit#access_token=dc891f4a-ac88-4ba6-8224-a2497e013865&token_type=bearer&expires_in=43199\n然后客户端通过JS等从hash值中取到access_token值.',
    `authorities` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '@PreAuthorize(\"hasAuthority(\'admin\')\")可以在方法上标志 用户或者说client 需要说明样的权限\n\n指定客户端所拥有的Spring Security的权限值,可选, 若有多个权限值,用逗号(,)分隔, 如: \"ROLE_UNITY,ROLE_USER\".\n对于是否要设置该字段的值,要根据不同的grant_type来判断, 若客户端在Oauth流程中需要用户的用户名(username)与密码(password)的(authorization_code,password),\n则该字段可以不需要设置值,因为服务端将根据用户在服务端所拥有的权限来判断是否有权限访问对应的API.\n但如果客户端在Oauth流程中不需要用户信息的(implicit,client_credentials),\n则该字段必须要设置对应的权限值, 因为服务端将根据该字段值的权限来判断是否有权限访问对应的API.\n\n(请在spring-oauth-client项目中来测试不同grant_type时authorities的变化)',
    `access_token_validity` int(11) NULL DEFAULT NULL COMMENT '设定客户端的access_token的有效时间值(单位:秒),可选, 若不设定值则使用默认的有效时间值(60 * 60 * 12, 12小时).\n在服务端获取的access_token JSON数据中的expires_in字段的值即为当前access_token的有效时间值.\n在项目中, 可具体参考DefaultTokenServices.java中属性accessTokenValiditySeconds.\n在实际应用中, 该值一般是由服务端处理的, 不需要客户端自定义.',
    `refresh_token_validity` int(11) NULL DEFAULT NULL COMMENT '	设定客户端的refresh_token的有效时间值(单位:秒),可选, 若不设定值则使用默认的有效时间值(60 * 60 * 24 * 30, 30天).\n若客户端的grant_type不包括refresh_token,则不用关心该字段 在项目中, 可具体参考DefaultTokenServices.java中属性refreshTokenValiditySeconds.\n在实际应用中, 该值一般是由服务端处理的, 不需要客户端自定义.',
    `additional_information` varchar(4096) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '这是一个预留的字段,在Oauth的流程中没有实际的使用,可选,但若设置值,必须是JSON格式的数据,如:\n{\"country\":\"CN\",\"country_code\":\"086\"}\n按照spring-security-oauth项目中对该字段的描述\nAdditional information for this client, not need by the vanilla OAuth protocol but might be useful, for example,for storing descriptive information.\n(详见ClientDetails.java的getAdditionalInformation()方法的注释) 在实际应用中, 可以用该字段来存储关于客户端的一些其他信息,如客户端的国家,地区,注册时的IP地址等等.',
    `autoapprove` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '设置用户是否自动Approval操作, 默认值为 \'false\', 可选值包括 \'true\',\'false\', \'read\',\'write\'.\n该字段只适用于grant_type=\"authorization_code\"的情况,当用户登录成功后,若该值为\'true\'或支持的scope值,则会跳过用户Approve的页面, 直接授权.',
     PRIMARY KEY (`client_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of oauth_client_details
-- ----------------------------
BEGIN;
INSERT INTO `oauth_client_details` VALUES ('OrderManagement', NULL, '$2a$10$8yVwRGY6zB8wv5o0kRgD0ep/HVcvtSZUZsYu/586Egxc1hv3cI9Q6', 'all', 'authorization_code,refresh_token', 'http://localhost:8083/orderSystem/login', NULL, 7200, NULL, NULL, 'true');
INSERT INTO `oauth_client_details` VALUES ('UserManagement', NULL, '$2a$10$ZRmPFVgE6o2aoaK6hv49pOt5BZIKBDLywCaFkuAs6zYmRkpKHgyuO', 'all', 'authorization_code,refresh_token', 'http://localhost:8082/memberSystem/login', NULL, 7200, NULL, NULL, 'true');
COMMIT;

-- ----------------------------
-- Table structure for sys_permission
-- ----------------------------
DROP TABLE IF EXISTS `sys_permission`;
CREATE TABLE `sys_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pid` int(11) DEFAULT '0' COMMENT '父ID',
  `type` tinyint(4) NOT NULL COMMENT '资源类型（1：菜单，2：按钮，3：操作）',
  `name` varchar(64) CHARACTER SET latin1 NOT NULL COMMENT '资源名称',
  `code` varchar(64) CHARACTER SET latin1 NOT NULL COMMENT '资源标识（或者叫权限字符串）',
  `uri` varchar(64) CHARACTER SET latin1 DEFAULT NULL COMMENT '资源URI',
  `seq` int(11) DEFAULT '1' COMMENT '序号',
  `create_user` varchar(64) CHARACTER SET latin1 DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `update_user` varchar(64) CHARACTER SET latin1 DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `idx_type` (`type`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of sys_permission
-- ----------------------------
BEGIN;
INSERT INTO `sys_permission` VALUES (1, 0, 3, 'add', 'member:add', '/member/add', 1, 'system', '2019-03-03 18:50:17', 'system', '2019-03-03 18:50:20');
INSERT INTO `sys_permission` VALUES (2, 0, 3, 'detail', 'member:detail', '/member/detail', 1, 'system', '2019-03-03 18:50:17', 'system', '2019-03-03 18:50:20');
COMMIT;

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role_name` varchar(32) NOT NULL COMMENT '角色名称',
  `role_code` varchar(32) NOT NULL,
  `role_description` varchar(64) DEFAULT NULL COMMENT '角色描述',
  `create_user` varchar(64) DEFAULT NULL,
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_user` varchar(64) DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
BEGIN;
INSERT INTO `sys_role` VALUES (1, '员工', 'normal', '普通员工', 'system', '2019-02-12 11:14:41', NULL, NULL);
INSERT INTO `sys_role` VALUES (2, '部门经理', 'manager', '部门经理', 'system', '2019-02-12 11:15:37', NULL, NULL);
INSERT INTO `sys_role` VALUES (3, '客服', 'kefu', '客服', 'system', '2019-02-12 11:16:27', NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for sys_role_permission
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_permission`;
CREATE TABLE `sys_role_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role_id` int(11) NOT NULL COMMENT '角色ID',
  `permission_id` int(11) NOT NULL COMMENT '权限ID',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of sys_role_permission
-- ----------------------------
BEGIN;
INSERT INTO `sys_role_permission` VALUES (1, 2, 1);
INSERT INTO `sys_role_permission` VALUES (2, 2, 2);
COMMIT;

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(64) NOT NULL COMMENT '账号',
  `password` varchar(256) NOT NULL COMMENT '密码',
  `nickname` varchar(64) NOT NULL COMMENT '昵称',
  `email` varchar(64) DEFAULT NULL COMMENT '邮箱',
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态（0：锁定，1：解锁）',
  `create_user` varchar(64) DEFAULT NULL,
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_user` varchar(64) DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
BEGIN;
INSERT INTO `sys_user` VALUES (1, 'admin', 'admin', '管理员', 'abc@123.com', 1, 'system', '2019-02-12 11:12:19', NULL, NULL);
INSERT INTO `sys_user` VALUES (2, 'zhangsan', '123456', '张三', 'zhangsan@126.com', 1, 'system', '2019-02-12 11:13:27', NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '用户ID',
  `role_id` int(11) NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
BEGIN;
INSERT INTO `sys_user_role` VALUES (1, 1, 1);
INSERT INTO `sys_user_role` VALUES (2, 1, 2);
INSERT INTO `sys_user_role` VALUES (3, 1, 3);
INSERT INTO `sys_user_role` VALUES (4, 2, 2);
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
