:- consult('menus.pl').
:- consult('display.pl').
:- consult('logic.pl').
:- consult('utilities.pl').
:- consult('input.pl').
:- consult('new.pl').
:- consult('bot.pl').
:- consult('utils.pl').
:- consult('moves.pl').
:- use_module(library(random)).
:- use_module(library(system)).

play :-
      mainMenu.
