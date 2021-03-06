Require Import syntax.
Require Import substitution.
From stdpp Require Import gmap.

(* pg. 140-141 *)

Inductive WellTTyped : gset type -> type -> Prop :=
  | TypT th t : WellTTyped (th ∪ {[Typ t]}) (Typ t)
  | ArrT th tau1 tau2 : WellTTyped th tau1 -> WellTTyped th tau2 -> WellTTyped th (Arr tau1 tau2)
  | AllT th t tau : WellTTyped (th ∪ {[Typ t]}) tau -> WellTTyped th (All t tau)
  .

Inductive WellTyped : gset type -> gmap var type -> expr -> type -> Prop :=
  | VarT th g x tau : WellTyped th (<[x:=tau]>g) (Var x) tau 
  | LamT th c e x tau tau' : WellTyped th (<[x:=tau]>c) e tau' -> WellTyped th c (Lam x tau e) (Arr tau tau')
  | AppT th c e1 e2 t t2 : WellTyped th c e1 (Arr t2 t) -> WellTyped th c e2 t2 -> WellTyped th c (App e1 e2) t
  | Lam2T g th e t tau : WellTyped (th ∪ {[Typ t]}) g e tau -> WellTyped th g (Lam2 t e) (All t tau)
  | App2T th g e t tau tau' : WellTyped th g e (All t tau') -> WellTTyped th tau -> WellTyped th g (App2 e tau) (subst_t_t tau' tau t)
  .