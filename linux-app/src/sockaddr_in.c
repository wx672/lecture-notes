struct in_addr {               /* IPv4 4-byte address */
    in_addr_t s_addr;          /* Unsigned 32-bit integer */
};

struct sockaddr_in {           /* IPv4 socket address */
    sa_family_t    sin_family; /* Address family (AF_INET) */
    in_port_t      sin_port;   /* Port number */
    struct in_addr sin_addr;   /* IPv4 address */
    unsigned char  __pad[X];   /* Pad to size of sockaddr (16 bytes) */
};
