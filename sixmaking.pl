:- consult('menus.pl').
:- consult('display.pl').
:- consult('logic.pl').
:- consult('utilities.pl').
:- consult('input.pl').
:- consult('utils.pl').
:- consult('moves.pl').
:- consult('bot.pl').

:- use_module(library(random)).
:- use_module(library(system)).

play :-
      mainMenu.
