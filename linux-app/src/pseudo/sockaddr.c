struct sockaddr {
  sa_family_t sa_family;   /* Address family (AF_* constant) */
  char        sa_data[14]; /* Socket address (size varies
							  according to socket domain) */
};
