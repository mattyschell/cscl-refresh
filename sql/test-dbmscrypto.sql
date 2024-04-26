DECLARE
    l_raw RAW(16) := UTL_RAW.cast_to_raw('test');
    l_encrypted RAW(2048);
BEGIN
    l_encrypted := sys.DBMS_CRYPTO.ENCRYPT(
        src => l_raw,
        typ => sys.DBMS_CRYPTO.ENCRYPT_AES256 + DBMS_CRYPTO.CHAIN_CBC + DBMS_CRYPTO.PAD_PKCS5,
        key => UTL_RAW.cast_to_raw('0123456789ABCDEF0123456789ABCDEF')
    );
    DBMS_OUTPUT.PUT_LINE('Encrypted text: ' || RAWTOHEX(l_encrypted));
END;
