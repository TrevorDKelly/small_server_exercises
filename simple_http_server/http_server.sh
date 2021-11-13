function server () {
  while true
  do
    message_arr=()
    check=true
    while $check
    do
      read line
      message_arr+=($line)
      if [[ "${#line}" -eq 1 ]]
      then
        check=false
      fi
    done
    method=${message_arr[0]}
    path=${message_arr[1]}
    if [[ $method = 'GET' ]]
    then
      if [[ -f "./www/$path" ]]
      then
        echo 'HTTP/1.1 200 OK';
        echo 'Content-Type: text/html; charset=utf-8'
        echo -e "Content-Length: $(wc -c < './www/'$path)\r\n";
        cat "./www/$path"
      else
        echo 'HTTP/1.1 404 Not Found'
        echo -e 'Content-Length: 0\r\n'
      fi
    else
      echo 'HTTP/1.1 400 Bad Request'
      echo -e 'Content-Length: 0\r\n'
    fi
  done
}

coproc SERVER_PROCESS { server; }

nc -lvck 2345 <&${SERVER_PROCESS[0]} >&${SERVER_PROCESS[1]}
