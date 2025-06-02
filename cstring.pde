/// port cpp cstring to processing
/// funcs, scripts
/// usage
/// char[] cstring = new char[buffer];
/// cstring[i] = 'C';
/// cstring[i + 1] = 'C';
/// cstring[i + 2] = 'C';
/// cstring[i + 3] = 'P';

int strlen(char[] buffer) {
  for (int i = 0; i < buffer.length; i++) {
    if (buffer[i] == '\0') return (i + 1);
  }
  return buffer.length;
}

boolean compareStr(char[] f, char[] s) {
  int sl = strlen(s);

  for (int i = 0; i < sl; i++) {
    if (f[i] != s[i]) {
      return false;
    }
  }
  return true;
}

boolean compareStr(char[] f, char[] s, int len) {
  for (int i = 0; i < len; i++) {
    if (f[i] != s[i]) {
      return false;
    }
  }
  return true;
}

byte[] getUntilTermintor(byte[] array, char terminator){
  byte[] res;
  for(int i = 0; i < array.length; i++){
    //ifs
  }
  return array;
}
