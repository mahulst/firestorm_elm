module Api.Home exposing (index)

import Api.Helpers
    exposing
        ( get
        )
import HttpBuilder exposing (withJsonBody, send, withExpect)
import Http
import Decoders exposing (categoriesAndThreadsAndUsersDecoder)
import Types.Category as Category
import Types.Thread as Thread
import Types.User as User
import Dict exposing (Dict)


index :
    String
    -> (( Dict Int Category.Model, Dict Int Thread.Model, Dict Int User.Model )
        -> msg
       )
    -> (Http.Error -> msg)
    -> Cmd msg
index apiBaseUrl tagger errorTagger =
    "home"
        |> get apiBaseUrl
        |> withExpect (Http.expectJson categoriesAndThreadsAndUsersDecoder)
        |> send (handleGetHomeComplete tagger errorTagger)


handleGetHomeComplete :
    (( Dict Int Category.Model, Dict Int Thread.Model, Dict Int User.Model ) -> msg)
    -> (Http.Error -> msg)
    -> Result Http.Error ( Dict Int Category.Model, Dict Int Thread.Model, Dict Int User.Model )
    -> msg
handleGetHomeComplete tagger errorTagger result =
    case Debug.log "handleGetHomeComplete" result of
        Ok categoriesAndThreadsAndUsers ->
            tagger categoriesAndThreadsAndUsers

        Err error ->
            errorTagger error