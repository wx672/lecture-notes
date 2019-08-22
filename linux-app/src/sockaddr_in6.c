struct in6_addr {               /* IPv6 address structure */
    uint8_t s6_addr[16];        /* 16 bytes == 128 bits */
};

struct sockaddr_in6 {           /* IPv6 socket address */
    sa_family_t sin6_family;    /* Address family (AF_INET6) */
    in_port_t   sin6_port;      /* Port number */
    uint32_t    sin6_flowinfo;  /* IPv6 flow information */
    struct in6_addr sin6_addr;  /* IPv6 address */
    uint32_t    sin6__scope_id; /* Scope ID (new in kernel 2.4) */
};
