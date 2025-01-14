(**************************************************************************)
(*                                                                        *)
(*                                 OCaml                                  *)
(*                                                                        *)
(*             Xavier Leroy, projet Cristal, INRIA Rocquencourt           *)
(*                                                                        *)
(*   Copyright 1996 Institut National de Recherche en Informatique et     *)
(*     en Automatique.                                                    *)
(*                                                                        *)
(*   All rights reserved.  This file is distributed under the terms of    *)
(*   the GNU Lesser General Public License version 2.1, with the          *)
(*   special exception on linking described in the file LICENSE.          *)
(*                                                                        *)
(**************************************************************************)

type 'a t = 'a array
(** An alias for the type of arrays. *)

(** Array operations. *)

external length : 'a array -> int = "%array_length"
(** Return the length (number of elements) of the given array. *)

external get : 'a array -> int -> 'a = "%array_safe_get"
(** [ArrayLabels.get a n] returns the element number [n] of array [a].
   The first element has number 0.
   The last element has number [ArrayLabels.length a - 1].
   You can also write [a.(n)] instead of [ArrayLabels.get a n].

   Raise [Invalid_argument]
   if [n] is outside the range 0 to [(ArrayLabels.length a - 1)]. *)

external set : 'a array -> int -> 'a -> unit = "%array_safe_set"
(** [ArrayLabels.set a n x] modifies array [a] in place, replacing
   element number [n] with [x].
   You can also write [a.(n) <- x] instead of [ArrayLabels.set a n x].

   Raise [Invalid_argument]
   if [n] is outside the range 0 to [ArrayLabels.length a - 1]. *)

external make : int -> 'a -> 'a array = "caml_make_vect"
(** [Array.make n x] returns a fresh array of length [n],
   initialized with [x].
   All the elements of this new array are initially
   physically equal to [x] (in the sense of the [==] predicate).
   Consequently, if [x] is mutable, it is shared among all elements
   of the array, and modifying [x] through one of the array entries
   will modify all other entries at the same time.

   Raise [Invalid_argument] if [n < 0] or [n > Sys.max_array_length].
   If the value of [x] is a floating-point number, then the maximum
   size is only [Sys.max_array_length / 2].*)

external create : int -> 'a -> 'a array = "caml_make_vect"
  [@@ocaml.deprecated "Use Array.make instead."]
(** @deprecated [Array.create] is an alias for {!Array.make}. *)

val init : int -> f:(int -> 'a) -> 'a array
(** [ArrayLabels.init n ~f] returns a fresh array of length [n],
   with element number [i] initialized to the result of [f i].
   In other terms, [ArrayLabels.init n ~f] tabulates the results of [f]
   applied to the integers [0] to [n-1].

   Raise [Invalid_argument] if [n < 0] or [n > Sys.max_array_length].
   If the return type of [f] is [float], then the maximum
   size is only [Sys.max_array_length / 2].*)

val make_matrix : dimx:int -> dimy:int -> 'a -> 'a array array
(** [ArrayLabels.make_matrix ~dimx ~dimy e] returns a two-dimensional array
   (an array of arrays) with first dimension [dimx] and
   second dimension [dimy]. All the elements of this new matrix
   are initially physically equal to [e].
   The element ([x,y]) of a matrix [m] is accessed
   with the notation [m.(x).(y)].

   Raise [Invalid_argument] if [dimx] or [dimy] is negative or
   greater than {!Sys.max_array_length}.
   If the value of [e] is a floating-point number, then the maximum
   size is only [Sys.max_array_length / 2]. *)

val create_matrix : dimx:int -> dimy:int -> 'a -> 'a array array
  [@@ocaml.deprecated "Use ArrayLabels.make_matrix instead."]
(** @deprecated [ArrayLabels.create_matrix] is an alias for
   {!ArrayLabels.make_matrix}. *)

val append : 'a array -> 'a array -> 'a array
(** [Array.append v1 v2] returns a fresh array containing the
   concatenation of the arrays [v1] and [v2]. *)

val concat : 'a array list -> 'a array
(** Same as {!Array.append}, but concatenates a list of arrays. *)

val sub : 'a array -> pos:int -> len:int -> 'a array
(** [ArrayLabels.sub a ~pos ~len] returns a fresh array of length [len],
   containing the elements number [pos] to [pos + len - 1]
   of array [a].

   Raise [Invalid_argument] if [pos] and [len] do not
   designate a valid subarray of [a]; that is, if
   [pos < 0], or [len < 0], or [pos + len > Array.length a]. *)

val copy : 'a array -> 'a array
(** [Array.copy a] returns a copy of [a], that is, a fresh array
   containing the same elements as [a]. *)

val fill : 'a array -> pos:int -> len:int -> 'a -> unit
(** [ArrayLabels.fill a ~pos ~len x] modifies the array [a] in place,
   storing [x] in elements number [pos] to [pos + len - 1].

   Raise [Invalid_argument] if [pos] and [len] do not
   designate a valid subarray of [a]. *)

val blit :
  src:'a array -> src_pos:int -> dst:'a array -> dst_pos:int -> len:int ->
    unit
(** [ArrayLabels.blit ~src ~src_pos ~dst ~dst_pos ~len] copies [len] elements
   from array [src], starting at element number [src_pos], to array [dst],
   starting at element number [dst_pos]. It works correctly even if
   [src] and [dst] are the same array, and the source and
   destination chunks overlap.

   Raise [Invalid_argument] if [src_pos] and [len] do not
   designate a valid subarray of [src], or if [dst_pos] and [len] do not
   designate a valid subarray of [dst]. *)

val to_list : 'a array -> 'a list
(** [Array.to_list a] returns the list of all the elements of [a]. *)

val of_list : 'a list -> 'a array
(** [Array.of_list l] returns a fresh array containing the elements
   of [l]. *)

val iter : f:('a -> unit) -> 'a array -> unit
(** [ArrayLabels.iter ~f a] applies function [f] in turn to all
   the elements of [a].  It is equivalent to
   [f a.(0); f a.(1); ...; f a.(Array.length a - 1); ()]. *)

val map : f:('a -> 'b) -> 'a array -> 'b array
(** [ArrayLabels.map ~f a] applies function [f] to all the elements of [a],
   and builds an array with the results returned by [f]:
   [[| f a.(0); f a.(1); ...; f a.(Array.length a - 1) |]]. *)

val iteri : f:(int -> 'a -> unit) -> 'a array -> unit
(** Same as {!ArrayLabels.iter}, but the
   function is applied to the index of the element as first argument,
   and the element itself as second argument. *)

val mapi : f:(int -> 'a -> 'b) -> 'a array -> 'b array
(** Same as {!ArrayLabels.map}, but the
   function is applied to the index of the element as first argument,
   and the element itself as second argument. *)

val fold_left : f:('a -> 'b -> 'a) -> init:'a -> 'b array -> 'a
(** [ArrayLabels.fold_left ~f ~init a] computes
   [f (... (f (f init a.(0)) a.(1)) ...) a.(n-1)],
   where [n] is the length of the array [a]. *)

val fold_right : f:('b -> 'a -> 'a) -> 'b array -> init:'a -> 'a
(** [ArrayLabels.fold_right ~f a ~init] computes
   [f a.(0) (f a.(1) ( ... (f a.(n-1) init) ...))],
   where [n] is the length of the array [a]. *)


(** {1 Iterators on two arrays} *)


val iter2 : f:('a -> 'b -> unit) -> 'a array -> 'b array -> unit
(** [ArrayLabels.iter2 ~f a b] applies function [f] to all the elements of [a]
   and [b].
   Raise [Invalid_argument] if the arrays are not the same size.
   @since 4.05.0 *)

val map2 : f:('a -> 'b -> 'c) -> 'a array -> 'b array -> 'c array
(** [ArrayLabels.map2 ~f a b] applies function [f] to all the elements of [a]
   and [b], and builds an array with the results returned by [f]:
   [[| f a.(0) b.(0); ...; f a.(Array.length a - 1) b.(Array.length b - 1)|]].
   Raise [Invalid_argument] if the arrays are not the same size.
   @since 4.05.0 *)


(** {1 Array scanning} *)


val exists : f:('a -> bool) -> 'a array -> bool
(** [ArrayLabels.exists ~f [|a1; ...; an|]] checks if at least one element of
    the array satisfies the predicate [f]. That is, it returns
    [(f a1) || (f a2) || ... || (f an)].
    @since 4.03.0 *)

val for_all : f:('a -> bool) -> 'a array -> bool
(** [ArrayLabels.for_all ~f [|a1; ...; an|]] checks if all elements
   of the array satisfy the predicate [f]. That is, it returns
   [(f a1) && (f a2) && ... && (f an)].
   @since 4.03.0 *)

val mem : 'a -> set:'a array -> bool
(** [mem x ~set] is true if and only if [x] is equal
   to an element of [set].
   @since 4.03.0 *)

val memq : 'a -> set:'a array -> bool
(** Same as {!ArrayLabels.mem}, but uses physical equality
   instead of structural equality to compare list elements.
   @since 4.03.0 *)

external create_float: int -> float array = "caml_make_float_vect"
(** [Array.create_float n] returns a fresh float array of length [n],
    with uninitialized data.
    @since 4.03 *)

val make_float: int -> float array
  [@@ocaml.deprecated "Use Array.create_float instead."]
(** @deprecated [Array.make_float] is an alias for
    {!Array.create_float}. *)


(** {1 Sorting} *)


val sort : cmp:('a -> 'a -> int) -> 'a array -> unit
(** Sort an array in increasing order according to a comparison
   function.  The comparison function must return 0 if its arguments
   compare as equal, a positive integer if the first is greater,
   and a negative integer if the first is smaller (see below for a
   complete specification).  For example, {!Stdlib.compare} is
   a suitable comparison function, provided there are no floating-point
   NaN values in the data.  After calling [ArrayLabels.sort], the
   array is sorted in place in increasing order.
   [ArrayLabels.sort] is guaranteed to run in constant heap space
   and (at most) logarithmic stack space.

   The current implementation uses Heap Sort.  It runs in constant
   stack space.

   Specification of the comparison function:
   Let [a] be the array and [cmp] the comparison function.  The following
   must be true for all x, y, z in a :
-   [cmp x y] > 0 if and only if [cmp y x] < 0
-   if [cmp x y] >= 0 and [cmp y z] >= 0 then [cmp x z] >= 0

   When [ArrayLabels.sort] returns, [a] contains the same elements as before,
   reordered in such a way that for all i and j valid indices of [a] :
-   [cmp a.(i) a.(j)] >= 0 if and only if i >= j
*)

val stable_sort : cmp:('a -> 'a -> int) -> 'a array -> unit
(** Same as {!ArrayLabels.sort}, but the sorting algorithm is stable (i.e.
   elements that compare equal are kept in their original order) and
   not guaranteed to run in constant heap space.

   The current implementation uses Merge Sort. It uses [n/2]
   words of heap space, where [n] is the length of the array.
   It is usually faster than the current implementation of {!ArrayLabels.sort}.
*)

val fast_sort : cmp:('a -> 'a -> int) -> 'a array -> unit
(** Same as {!ArrayLabels.sort} or {!ArrayLabels.stable_sort}, whichever is
    faster on typical input.
*)


(** {1 Iterators} *)

val to_seq : 'a array -> 'a Seq.t
(** Iterate on the array, in increasing order
    @since 4.07 *)

val to_seqi : 'a array -> (int * 'a) Seq.t
(** Iterate on the array, in increasing order, yielding indices along elements
    @since 4.07 *)

val of_seq : 'a Seq.t -> 'a array
(** Create an array from the generator
    @since 4.07 *)

(**/**)

(** {1 Undocumented functions} *)

(* The following is for system use only. Do not call directly. *)

external unsafe_get : 'a array -> int -> 'a = "%array_unsafe_get"
external unsafe_set : 'a array -> int -> 'a -> unit = "%array_unsafe_set"

module Floatarray : sig
  external create : int -> floatarray = "caml_floatarray_create"
  external length : floatarray -> int = "%floatarray_length"
  external get : floatarray -> int -> float = "%floatarray_safe_get"
  external set : floatarray -> int -> float -> unit = "%floatarray_safe_set"
  external unsafe_get : floatarray -> int -> float = "%floatarray_unsafe_get"
  external unsafe_set : floatarray -> int -> float -> unit
      = "%floatarray_unsafe_set"
end
