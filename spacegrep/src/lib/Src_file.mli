(*
   A representation of the input document, used to recover code snippets
   from locations.
*)

type t

type source =
  | File of string
  | Stdin
  | String
  | Channel

(*
   Read data from various sources.
   Specifying max_len allows for reading at most the first max_len bytes
   of data.
*)
val of_string : ?source:source -> string -> t
val of_channel : ?source:source -> ?max_len:int -> in_channel -> t
val of_stdin : ?source:source -> unit -> t
val of_file : ?source:source -> ?max_len:int -> string -> t

val to_lexbuf : t -> Lexing.lexbuf

val source : t -> source
val show_source : source -> string
val source_string : t -> string

val contents : t -> string
val length : t -> int

(*
   Extract a specific region specified as
   (start position, end position to be excluded).
 *)
val region_of_pos_range : t -> Lexing.position -> Lexing.position -> string

(*
   Extract a specific region specified by the positions of the first
   and last tokens to be included in the region.
*)
val region_of_loc_range : t -> Loc.t -> Loc.t -> string

(*
   Extract the lines containing a pair of positions.

   This includes the beginning of the first line and the end of the last line
   even if they're outside the requested range.
*)
val lines_of_pos_range :
  ?highlight:(string -> string) ->
  ?line_prefix:string ->
  t -> Lexing.position -> Lexing.position -> string

(*
   Extract the lines containing a pair of locations.
   A location itself is a range of positions, typically associated with
   an input token.
*)
val lines_of_loc_range :
  ?highlight:(string -> string) ->
  ?line_prefix:string ->
  t -> Loc.t -> Loc.t -> string

(* not for public use, only exposed to allow unit tests *)
val insert_highlight : (string -> string) -> string -> int -> int -> string
