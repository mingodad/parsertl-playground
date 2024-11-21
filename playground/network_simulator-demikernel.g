//From: https://github.com/microsoft/demikernel/blob/6c8a75a7277c54115a94a458c11b01ec165742b9/network_simulator/src/grammar.y
// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.

%token ACCEPT
%token ACK
%token BIND
%token CLOSE
//%token COLON
%token COMMA
%token CONNECT
%token DOT
%token ECR
%token ELLIPSIS
%token EOL
%token EQUALS
%token F
%token FLOAT
%token GETSOCKOPT
%token GT
%token IDENTIFIER
%token INTEGER
%token IPPROTO_TCP
%token IPPROTO_UDP
//%token LBRACE
%token LBRACKET
%token LEN
%token LISTEN
%token LPAREN
%token LT
//%token MINUS
%token MSS
%token NOP
%token P
%token PLUS
%token R
//%token RBRACE
%token RBRACKET
%token READ
%token RECV
%token RPAREN
%token S
%token SACKOK
%token SEND
%token SENDTO
%token SEQ
%token SETSOCKOPT
%token SOCKET
%token SOCK_DGRAM
%token SOCK_STREAM
%token TCP
%token TIMESTAMP
%token UDP
%token VAL
%token WAIT
%token WIN
%token WRITE
%token WSCALE

%start Script

%%

Script
      : %empty
      | Event
      | Script Event
      ;

Event
      : EventTime Action
      ;

EventTime
      : Time
      | PLUS Time
      ;

Time
      : FLOAT
      | INTEGER
      ;

Action
      : SyscallEvent
      | PacketEvent
      ;

SyscallEvent
      : OptionalEndTime Syscall
      ;

Syscall
      : SOCKET LPAREN SocketArgs RPAREN EQUALS Expression
      | BIND LPAREN BindArgs RPAREN EQUALS Expression
      | LISTEN LPAREN ListenArgs RPAREN EQUALS Expression
      | ACCEPT LPAREN AcceptArgs RPAREN EQUALS Expression
      | CONNECT LPAREN ConnectArgs RPAREN EQUALS Expression
      | SEND LPAREN WriteArgs RPAREN EQUALS Expression
      | SENDTO LPAREN SendToArgs RPAREN EQUALS Expression
      | RECV LPAREN ReadArgs RPAREN EQUALS Expression
      | CLOSE LPAREN CloseArgs RPAREN EQUALS Expression
      | WRITE LPAREN WriteArgs RPAREN EQUALS Expression
      | READ LPAREN ReadArgs RPAREN EQUALS Expression
      | WAIT LPAREN WaitArgs RPAREN EQUALS Expression
      | GETSOCKOPT LPAREN SyscallArgs RPAREN EQUALS Expression
      | SETSOCKOPT LPAREN SyscallArgs RPAREN EQUALS Expression
      ;

SocketArgs
      : ELLIPSIS COMMA SOCK_STREAM COMMA IPPROTO_TCP
      | ELLIPSIS COMMA SOCK_DGRAM COMMA IPPROTO_UDP
      ;

BindArgs
      : INTEGER COMMA ELLIPSIS COMMA ELLIPSIS
      ;

ListenArgs
      : INTEGER COMMA INTEGER
      ;

AcceptArgs
      : INTEGER COMMA ELLIPSIS COMMA ELLIPSIS
      ;

ConnectArgs
      : INTEGER COMMA ELLIPSIS COMMA ELLIPSIS
      ;

WriteArgs
      : INTEGER COMMA ELLIPSIS COMMA INTEGER
      ;

SendToArgs
      : INTEGER COMMA ELLIPSIS COMMA INTEGER
      ;

ReadArgs
      : INTEGER COMMA ELLIPSIS COMMA INTEGER
      ;

WaitArgs
      : INTEGER COMMA ELLIPSIS
      ;

CloseArgs
      : INTEGER
      ;

OptionalEndTime
      : %empty
      | ELLIPSIS Time
      ;

SyscallArgs
      : %empty
      | ExpressionList
      ;

ExpressionList
      : Expression
      | ExpressionList COMMA Expression
      ;

Expression
      : ELLIPSIS
      | IDENTIFIER
      | INTEGER
      | Array
      ;

Array
      : LBRACKET RBRACKET
      | LBRACKET Expression RBRACKET
      ;

PacketEvent
      : TCP Direction TcpPacket
      | UDP Direction UdpPacket
      ;

Direction
      : LT
      | GT
      ;

TcpPacket
      : TcpFlags TcpSequenceNumber OptionalAck OptionalWindow OptionalTcpOptions
      ;

TcpFlags
      : %empty
      | DOT TcpFlags
      | F TcpFlags
      | S TcpFlags
      | P TcpFlags
      | R TcpFlags
      ;

TcpSequenceNumber
      : SEQ INTEGER LPAREN INTEGER RPAREN
      ;

OptionalAck
      : %empty
      | ACK INTEGER
      ;

OptionalWindow
      : %empty
      | WIN INTEGER
      ;

OptionalTcpOptions
      : %empty
      | LT TcpOptionsList GT
      ;

TcpOptionsList
      : ELLIPSIS
      | TcpOption
      | TcpOptionsList COMMA TcpOption
      ;

TcpOption
      : NOP
      | EOL
      | MSS INTEGER
      | WSCALE INTEGER
      | SACKOK
      | TIMESTAMP VAL INTEGER ECR INTEGER
      ;

UdpPacket
      : LEN INTEGER
      ;

%%

%%
\( LPAREN
\) RPAREN
//\{ LBRACE
//\} RBRACE
\[ LBRACKET
\] RBRACKET
\< LT
\> GT
//\: COLON
\. DOT
\= EQUALS
\+ PLUS
//\- MINUS
\, COMMA
F   F
S   S
P   P
R   R
ack ACK
len LEN
win WIN
nop NOP
ecr ECR
eol EOL
mss MSS
seq SEQ
wscale WSCALE
socket SOCKET
bind BIND
listen LISTEN
accept ACCEPT
connect CONNECT
close CLOSE
send SEND
sendto SENDTO
recv RECV
read READ
TCP TCP
UDP UDP
wait WAIT
sackOK SACKOK
val VAL
write WRITE
getsockopt GETSOCKOPT
setsockopt SETSOCKOPT
SOCK_STREAM SOCK_STREAM
SOCK_DGRAM SOCK_DGRAM
IPPROTO_TCP IPPROTO_TCP
IPPROTO_UDP IPPROTO_UDP
TS TIMESTAMP
[-]?[0-9]*\.[0-9]+ FLOAT
[-]?[0-9]+ INTEGER
[A-Za-z_][a-zA-Z0-9_]* IDENTIFIER
\.\.\. ELLIPSIS
\/\/[^\n]* skip()
\`[^`]*\` skip()
[ \t\r\n]+ skip()

%%
