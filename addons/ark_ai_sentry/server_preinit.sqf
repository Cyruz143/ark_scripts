ark_ai_sentry_fnc_make_sentry = {
    params ["_unit", "_enabledNightvision"];

    if (isNil "_unit") exitWith {
        diag_log "[ARK] (AI Sentry) - Not synced to any units";
    };

    private _grp = group _unit;
    _grp enableAttack false;
    _grp enableDynamicSimulation true;

    [_grp, (getposASL _unit), 0, "GUARD", "AWARE", "YELLOW"] call CBA_fnc_addWaypoint;
    _unit allowFleeing 0;
    _unit disableAI "PATH";
    {
        _unit setSkill _x;
    } foreach [
        ["aimingAccuracy",0.2],
        ["aimingShake",0.15],
        ["aimingSpeed",0.5],
        ["spotDistance",0.4],
        ["spotTime",1],
        ["courage",1],
        ["reloadSpeed",1],
        ["commanding",1],
        ["general",0.7]
    ];

    private _hmd = hmd _unit;

    if (_enabledNightvision) then {
        // If unit has NVGs by default, keep them as they'll look better than fake invisible ones
        if (_hmd isEqualTo "") then {
            _unit linkItem "NVGoggles_AI";
        }
    } else {
        _unit unlinkItem _hmd;
    };
};

ark_ai_sentry_module_make_sentry = {
    params ["_logic","_units","_activated"];

    if !(_activated) exitWith {
        diag_log "[ARK] (AI Sentry) - Logic not activated";
    };

    if (_units isEqualTo []) exitWith {
        diag_log "[ARK] (AI Sentry) - Not synced to any units";
    };

    private _enabledNightvision = _logic getVariable ["Enabled_Nightvision", true];

    {
        [_x, _enabledNightvision] call ark_ai_sentry_fnc_make_sentry;
    } forEach _units;
};