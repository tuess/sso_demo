package com.cjs.sso.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.oauth2.config.annotation.configurers.ClientDetailsServiceConfigurer;
import org.springframework.security.oauth2.config.annotation.web.configuration.AuthorizationServerConfigurerAdapter;
import org.springframework.security.oauth2.config.annotation.web.configuration.EnableAuthorizationServer;
import org.springframework.security.oauth2.config.annotation.web.configurers.AuthorizationServerEndpointsConfigurer;
import org.springframework.security.oauth2.config.annotation.web.configurers.AuthorizationServerSecurityConfigurer;
import org.springframework.security.oauth2.provider.token.DefaultTokenServices;
import org.springframework.security.oauth2.provider.token.TokenEnhancerChain;
import org.springframework.security.oauth2.provider.token.store.JwtAccessTokenConverter;
import org.springframework.security.oauth2.provider.token.store.JwtTokenStore;

import javax.sql.DataSource;
import java.util.Arrays;
import java.util.Collections;

/**
 * @author ChengJianSheng
 * @date 2019-02-11
 */
@Configuration
@EnableAuthorizationServer
public class AuthorizationServerConfig extends AuthorizationServerConfigurerAdapter {

    @Autowired
    private DataSource dataSource;

    @Autowired
    private AuthenticationManager authenticationManager;

    /**
     * 用来配置令牌端点的安全约束
     */
    @Override
    public void configure(AuthorizationServerSecurityConfigurer security) throws Exception {
        security.allowFormAuthenticationForClients();
        security.tokenKeyAccess("isAuthenticated()");
    }

    /**
     * 用来配置客户端详情服务
     */
    @Override
    public void configure(ClientDetailsServiceConfigurer clients) throws Exception {
        /*
         *传来的参数clients是我们的应用，要去找授权服务器授权，授权完了之后会给我们授权码，我们
         * （client）拿着授权码再到授权服务器去获取令牌，获取到令牌之后拿着令牌去资源服务器获取资源
         * */

        //此处是存在数据库oauth_client_details表中
        clients.jdbc(dataSource);

/*        clients.inMemory() //.inMemory()放入内存。我们为了方便，直接放在内存中生成client，正常情况下是我们主动找授权服务器注册的时候才会有处理。
                .withClient("client") //指定client。参数为唯一client的id
                .secret(passwordEncoder.encode("112233")) //指定密钥
                .redirectUris("http://www.baidu.com") //指定重定向的地址,通过重定向地址拿到授权码。
                //.redirectUris("http://localhost:8081/login") //单点登录到另一服务器
                .accessTokenValiditySeconds(60 * 10) //设置Access Token失效时间
                .refreshTokenValiditySeconds(60 * 60 * 24) //设置refresh token失效时间
                .scopes("all") //指定授权范围
                .autoApprove(true) //自动授权，不需要手动允许了
                */
        /**
         * 授权类型：
         * "authorization_code" 授权码模式
         * "password"密码模式
         * "refresh_token" 刷新令牌
         *//*
                .authorizedGrantTypes("authorization_code", "password", "refresh_token"); //指定授权类型 可以多种授权类型并存。*/
    }

    /**
     *用来配置令牌（token）的访问端点和令牌服务(token services)。
     */
    @Override
    public void configure(AuthorizationServerEndpointsConfigurer endpoints) throws Exception {
        endpoints.accessTokenConverter(jwtAccessTokenConverter());
        endpoints.tokenStore(jwtTokenStore());
        endpoints.tokenServices(defaultTokenServices());
        //密码模式下 该配置必须有
        endpoints.authenticationManager(authenticationManager);
    }


    @Bean
    public DefaultTokenServices defaultTokenServices() {
        DefaultTokenServices defaultTokenServices = new DefaultTokenServices();
        defaultTokenServices.setTokenStore(jwtTokenStore());
        defaultTokenServices.setSupportRefreshToken(true);
        //配置返回jwt格式的token 转换
        defaultTokenServices.setTokenEnhancer(tokenEnhancerChain());
        return defaultTokenServices;
    }

    @Bean
    public JwtTokenStore jwtTokenStore() {
        return new JwtTokenStore(jwtAccessTokenConverter());
    }

    @Bean
    public JwtAccessTokenConverter jwtAccessTokenConverter() {
        JwtAccessTokenConverter jwtAccessTokenConverter = new JwtAccessTokenConverter();
        jwtAccessTokenConverter.setSigningKey("cjs");
        return jwtAccessTokenConverter;
    }

    //配置返回jwt格式的token 转换
    public TokenEnhancerChain tokenEnhancerChain() {
        TokenEnhancerChain tokenEnhancerChain = new TokenEnhancerChain();
        tokenEnhancerChain.setTokenEnhancers(Collections.singletonList(jwtAccessTokenConverter()));
        return tokenEnhancerChain;
    }

}
