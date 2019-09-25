struct sockaddr_un {
  sa_family_t sun_family; /* Always AF_UNIX */
  char sun_path[108];     /* Null-terminated socket pathname */
};
