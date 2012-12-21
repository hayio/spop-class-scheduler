module Config where

-- ile maksymalnie godzin moze miec grupa w jednym dniu
type MaxGroupHours = Int

-- godzina, od ktorej zajecia zaczynaja sie
type StartDayTime = Int

-- godzina, do ktorej trwaja zajecia
type EndDayTime = Int

-- Konfiguracja zajec modelu
data Config = Config MaxGroupHours StartDayTime EndDayTime