(** Database SQL Functions.

    This module contains all of the SQL functions used to manipulate and
    extract data from a database. *)

type db_list
(** Json list representation of a set of databases. *)

exception ValNotFound of string
(** Raised when a value is searched for and not found in a database. *)

exception FieldNotFound of string
(** Raised when a field is searched for and not found in a database. *)

exception DatabaseNotFound of string
(** Raised when a database is searched for and not found in a file or
    database. *)

exception InvalidRow of string
(** Raised when an invalid row is searched for in a database. *)

exception CannotConvertElement
(** Raised when trying to convert a string to some element is
    unsuccessful. *)

exception CannotCompute
(** Raised when trying to compute something unsuccessfully. *)

exception InvalidShape
(** Raised when a row of incorrect shape (incorrect # of fields/values)
    attempts to be added to a database table. *)

exception WrongType of (string * string)
(** [Wrongtype (value, field_type)] is raised when value [value] does
    not match the type [field_type] of the field it is being added to.*)

val file_location : string
(** Default file path of main DBMS*)

val set_file_location : string -> string
(** [set_file_location file] sets the location of the file [file] for
    the current database. Requires: [file] must be a legal json file in
    the data directory*)

val dbs_from_file : string -> Yojson.Basic.t
(** [dbs_from_file file] retrieves the json representation of database
    file [file]. *)

val database_string : string -> string
(** [database_string file] converts json database in file [file] to a
    json string of individual databases. *)

val write_to_file : string -> Yojson.Basic.t -> unit
(** [write_to_file file db] writes [db] to database file [file]. *)

val splice_outer_parens : string -> string
(** [splice_outer_parens dbm] removes the outer parentheses of database
    management object [dbm] to allow for later insertion of another
    database inside. Returns with trailing comma if inside parens is not
    empty. Requires: [dbm] must have length of at least 2, representing
    the constant 2 outer parentheses of the database management object. *)

val add_database : string -> string -> (string * string) list -> unit
(** [add_database file name field_types] adds a new database labeled
    [name] with values [fields_types] to the database list in file
    [file] -- Yojson.Basic.to_file file (Yojson.Basic.from_string str). *)

val add_database_t : string -> string -> Yojson.Basic.t -> unit
(** [add_database_t file name values] adds a new database labeled [name]
    with values [values] to the datbase list in file file [file]. Does
    the same thing as [add_databse file name values] except with an
    input of type Yojson.Basic.t instead of string list for [values]. *)

val clear_database_file : string -> unit
(** [clear_database_file file] clears the whole database file [file], so
    that there are no databases in the file. *)

val delete_database : string -> string -> unit
(** [delete_database file name] removes the database with name [name]
    from the database file [file]. Removes the first instance of a
    database with name [name] in [file] if there are multiple databases
    with the same name. Raises: DatabaseNotFound "database_name" if the
    [database_name] is not in [file]. *)

val clear_database : string -> string -> unit
(** [clear_database file name] clears te database with name [name] from
    the database file [file]. The database remains in the file, but its
    values are removed. Clears the first instance of a database with
    name [name] in [file] if there are multiple databases with the same
    name. If [name] is not in the database file [file], then the same
    file is returned unchanged. *)

val find_database : string -> string -> Yojson.Basic.t
(** [find_database file database_name] returns the contents of the
    database [database_name] in database file [file]. Raises:
    DatabaseNotFound "database_name" if the [database_name] is not in
    [file]. *)

val find_value_in_database : string -> string -> string -> string
(** [find_value_in_database file database_name value_name] returns the
    value associated with the value [value_name] in the database
    [database_name]. Requires: The value is a string. Raises:
    ValNotFound "value_name" if the [value_name] is not in
    [database_name]. *)

val get_db_names_list : string -> string
(** [get_db_names_list file] returns a string of each database name in
    the system in [file], each separated by a newline for printing into
    console. *)

val get_field_type : string -> string -> string -> string
(** [get_field_type file db_name field] returns a string representation
    of the type of field [field] in database [db_name] *)

val list_rows : string -> string -> unit
(** [list_rows file database_name] prints a formatted string of values
    for each row a database in [file] given by [database_name], with
    each row separated by a newline. *)

val add_element_to_database : string -> string -> string -> unit
(** [add_element_to_database file database_name value_name] adds the
    element [value_name] to the template of database [database_name] in
    [file]. *)

val add_field_to_all_rows :
  string -> ?val_name:string -> string -> string -> string -> unit
(** [add_element_to_all_database file value_name database_name field_name field_type]
    adds the field [field_name] with type [field_type] with optional
    [value_name] to all rows of the database [database_name] in [file]. *)

val delete_field : string -> string -> string -> unit
(** [delete_field file db_name field_name] removes the column with field
    [field_name] from database [db_name]. *)

val find_row : string -> string -> string -> string -> int list
(** [find_row file database_name field_name value_name] returns the row
    numbers of which [field_name] corresponds to [value_name] in an
    array sorted from lowest row number first to highest last. *)

val update_value : string -> string -> string -> int -> string -> unit
(** [update_value file db_name field_name element_row new_value] updates
    the value in [file] in [db_name] with field name [field_name] in the
    [element_row]th row of the database to new value [new_value]. The
    first row after the template row in the database corresponds to
    [element_row] = 1. If [field_name] is not in [db_name] then raises
    FieldNotFound. Requires: [element_row] >= 1 and is a valid row in
    the [database_name]. *)

val update_all : string -> string -> string -> string -> unit
(** [update_element file database_name field_name new_value] updates all
    the elements in [file] in [database_name] with field name
    [field_name] to new value [new_value]. If [field_name] is not in
    [database_name] then raises FieldNotFound. *)

val delete_rows_in_database : string -> int list -> string -> unit
(** [delete_rows_in_database file database_name comp_field comp_val]
    deletes all the rows in [file] in [database_name] with field name
    [comp_val] set to value [comp_value]. If [field_name] is not in
    [database_name] then raises FieldNotFound. *)

val add_row : string -> string -> string list -> unit
(** [add_row file db_name field_val_pairs] adds a new row of the
    corresponding field value pairs to the database with name [db_name] *)

val get_fields_list : string -> string -> string list
(** [get_fields_list file db_name] lists the string titles of each field
    in the shape of database [db_name] inside [file]. *)

val sort_rows : string -> string -> string -> unit
(** [sort_rows file db_name sort_field] sorts the rows of database
    [db_name] in file [file] according to each row's value in field
    [sort_field]*)

val sum_of_field : string -> string -> string -> string
(** [sum_of_field file db_name field_name] gives the sum of all of the
    values with field name [field_name] in [db_name] in [file]. *)

val mean_of_field : string -> string -> string -> string
(** [mean_of_field file db_name field_name] gives the mean of all of the
    values with field name [field_name] in [db_name] in [file]. *)
