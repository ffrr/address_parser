module AddressParser::StreetTypes
  STREET_TYPES = [
    [ 'Access', 'accs' ],
    [ 'Alley', 'ally' ],
    [ 'Approach', 'app' ],
    [ 'Arcade', 'arc' ],
    [ 'Artery', 'art' ],
    [ 'Avenue', 'ave' ],
    [ 'Bank', 'bnk' ],
    [ 'Basin', 'basn' ],
    [ 'Bay', 'by' ],
    [ 'Beach', 'bch' ],
    [ 'Bend', 'bend' ],
    [ 'Building' ],
    [ 'Boulevard', 'bvd', 'blvd' ],
    [ 'Boardwalk' ],
    [ 'Bowl', 'bwl' ],
    [ 'Brace', 'brce' ],
    [ 'Brae', 'brae' ],
    [ 'Break', 'brk' ],
    [ 'Bridge', 'bdge' ],
    [ 'Broadway', 'bdwy' ],
    [ 'Brook' ],
    [ 'Brow', 'brow' ],
    [ 'Bypass', 'bypa' ],
    [ 'Canal' ],
    [ 'Causeway', 'caus' ],
    [ 'Centre', 'ctr' ],
    [ 'Centreway', 'cnwy' ],
    [ 'Chase', 'ch' ],
    [ 'Circle', 'cir' ],
    [ 'Circlet', 'clt' ],
    [ 'Circuit', 'cct' ],
    [ 'Circus', 'crcs' ],
    [ 'Close', 'cl' ],
    [ 'Common', 'cmmn' ],
    [ 'Concourse', 'con' ],
    [ 'Copse', 'cps' ],
    [ 'Corner', 'cnr' ],
    [ 'Corso', 'cso' ],
    [ 'Course', 'crs' ],
    [ 'Court', 'ct, crt' ],
    [ 'Courtyard', 'ctyd' ],
    [ 'Cove', 'cove' ],
    [ 'Crescent', 'cres', 'crsnt' ],
    [ 'Crest', 'crst' ],
    [ 'Crief', 'crf' ],
    [ 'Cross', 'crss' ],
    [ 'Crossing', 'crsg' ],
    [ 'Culdesac', 'cds' ],
    [ 'Curve' ],
    [ 'Dale', 'dale' ],
    [ 'Deviation', 'devn' ],
    [ 'Dip', 'dip' ],
    [ 'Downs', 'dwns' ],
    [ 'Drive', 'dr' ],
    [ 'Driveway', 'drwy' ],
    [ 'Easement', 'easmnt' ],
    [ 'Edge', 'edge' ],
    [ 'Elbow', 'elb' ],
    [ 'End', 'end' ],
    [ 'Entrance', 'ent' ],
    [ 'Esplanade', 'esp' ],
    [ 'Estate', 'est' ],
    [ 'Expressway', 'exp' ],
    [ 'Extension', 'extn' ],
    [ 'Fairway', 'fawy' ],
    [ 'Firetrail', 'fitr' ],
    [ 'Follow', 'folw' ],
    [ 'Ford' ],
    [ 'Formation', 'form' ],
    [ 'Freeway', 'fwy' ],
    [ 'Front', 'frnt' ],
    [ 'Frontage', 'frtg' ],
    [ 'Gap', 'gap' ],
    [ 'Garden', 'gdn' ],
    [ 'Gardens', 'gdns' ],
    [ 'Gate', 'gte' ],
    [ 'Gates', 'gtes' ],
    [ 'Gateway', 'gtwy' ],
    [ 'Glade', 'gld' ],
    [ 'Glen', 'glen' ],
    [ 'Grange', 'gra' ],
    [ 'Green', 'grn' ],
    [ 'Ground', 'grnd' ],
    [ 'Grove', 'gr' ],
    [ 'Grovet' ],
    [ 'Haven' ],
    [ 'Heath', 'hth' ],
    [ 'Heights', 'hts' ],
    [ 'Hill', 'hill' ],
    [ 'Hub' ],
    [ 'Highway', 'hwy' ],
    [ 'Interchange', 'intg' ],
    [ 'Island', 'is' ],
    [ 'Junction', 'jnc' ],
    [ 'Key', 'key' ],
    [ 'Knoll' ],
    [ 'Lane', 'lne, ln, la' ],
    [ 'Line', 'line' ],
    [ 'Laneway', 'lnwy' ],
    [ 'Link', 'link' ],
    [ 'Lookout', 'lkt' ],
    [ 'Loop', 'loop' ],
    [ 'Lower', 'lwr' ],
    [ 'Mall', 'mall' ],
    [ 'Mead' ],
    [ 'Meander', 'mndr' ],
    [ 'Mews', 'mews' ],
    [ 'Motorway', 'mwy' ],
    [ 'Nook', 'nook' ],
    [ 'Outlook', 'otlk' ],
    [ 'Overpass' ],
    [ 'Property' ],
    [ 'Park', 'park' ],
    [ 'Parklands', 'pkld' ],
    [ 'Parkway', 'pkwy' ],
    [ 'Pass', 'pass' ],
    [ 'Path', 'path' ],
    [ 'Pathway', 'phwy' ],
    [ 'Parade', 'pde' ],
    [ 'Pier', 'pr' ],
    [ 'Place', 'pl' ],
    [ 'Plaza', 'plza' ],
    [ 'Pocket', 'pkt' ],
    [ 'Point', 'pnt' ],
    [ 'Port', 'port' ],
    [ 'Promenade', 'prom' ],
    [ 'Pursuit', 'pur' ],
    [ 'Quad', 'quad' ],
    [ 'Quadrant', 'qdrt' ],
    [ 'Quay', 'qy' ],
    [ 'Quays', 'qys' ],
    [ 'Ramble', 'rmbl' ],
    [ 'Road', 'rd' ],
    [ 'Reach', 'rch' ],
    [ 'Reserve', 'res' ],
    [ 'Rest', 'rest' ],
    [ 'Retreat', 'rtt' ],
    [ 'Return', 'rtrn' ],
    [ 'Ride', 'ride' ],
    [ 'Ridge', 'rdge' ],
    [ 'Ring', 'ring' ],
    [ 'Rise', 'rise' ],
    [ 'Rising' ],
    [ 'Roadway', 'rdwy' ],
    [ 'Rotary', 'rty' ],
    [ 'Round', 'rnd' ],
    [ 'Route', 'rte' ],
    [ 'Row', 'row' ],
    [ 'Run', 'run' ],
    [ 'Serviceway', 'service way', 'swy' ],
    [ 'Siding', 'sdng' ],
    [ 'Slope', 'slpe' ],
    [ 'Spur', 'spur' ],
    [ 'Square', 'sq' ],
    [ 'Steps', 'stps' ],
    [ 'Strand', 'stra' ],
    [ 'Street', 'st' ],
    [ 'Strip', 'strp' ],
    [ 'Subway', 'sbwy' ],
    [ 'Tarn', 'tarn' ],
    [ 'Terrace', 'tce', 'ter', 'terr' ],
    [ 'Throughway' ],
    [ 'Tollway', 'tlwy' ],
    [ 'Top', 'top' ],
    [ 'Tor', 'tor' ],
    [ 'Track', 'trk' ],
    [ 'Trail', 'trl' ],
    [ 'Turn', 'turn' ],
    [ 'Underpass', 'upas' ],
    [ 'Vale', 'vale' ],
    [ 'Valley' ],
    [ 'View', 'view' ],
    [ 'Vista', 'vsta' ],
    [ 'Walk', 'walk' ],
    [ 'Walkway', 'wkwy' ],
    [ 'Way', 'way' ],
    [ 'Wharf', 'whrf' ],
    [ 'Wynd', 'wynd' ],
    [ 'Street North' ],
    [ 'Street South' ],
    [ 'Street East' ],
    [ 'Street West' ],
    [ 'Parade East' ],
    [ 'Parade West' ],
    [ 'Righi' ],
    [ 'Eyrie' ],
    [ 'Concord' ],
    [ 'Conder' ],
    [ 'Conduit' ],
    [ 'Oaks' ],
    [ 'Panorama' ],
    [ 'Ridgeway', 'rgwy' ],
    [ 'Road North' ],
    [ 'Road South' ],
    [ 'Boulevarde' ],
    [ 'Station' ],
    [ 'Parade South' ],
    [ 'Parade North' ],
    [ 'Road West' ],
    [ 'Road East' ],
    [ 'Waters', 'wtrs' ],
    [ 'Boulevard North' ],
    [ 'Avenue North' ],
    [ 'Alleyway', 'alwy' ],
    [ 'Amble', 'ambl' ],
    [ 'Anchorage', 'ancg' ],
    [ 'Block', 'blk' ],
    [ 'Byway', 'bywy' ],
    [ 'Colonnade', 'clde' ],
    [ 'Crossroad', 'crd' ],
    [ 'Crossway', 'cowy' ],
    [ 'Cruiseway', 'cuwy' ],
    [ 'Cutting', 'cttg' ],
    [ 'Dell', 'dell' ],
    [ 'Distributor', 'dstr' ],
    [ 'Fire track', 'ftrk' ],
    [ 'Flat', 'flat' ],
    [ 'Footway', 'ftwy' ],
    [ 'Foreshore', 'fshr' ],
    [ 'Gully', 'gly' ],
    [ 'Highroad', 'hrd' ],
    [ 'Intersection', 'intn' ],
    [ 'Landing', 'ldg' ],
    [ 'Lees', 'lees' ],
    [ 'Little', 'lt' ],
    [ 'Mew', 'mew' ],
    [ 'Mount', 'mt' ],
    [ 'Part', 'part' ],
    [ 'Piazza', 'piaz' ],
    [ 'Plateau', 'plat' ],
    [ 'Quadrangle', 'qdgl' ],
    [ 'Ramp', 'ramp' ],
    [ 'Range', 'rnge' ],
    [ 'Right of way', 'rowy' ],
    [ 'River', 'rvr' ],
    [ 'Riverway', 'rvwy' ],
    [ 'Riviera', 'rvra' ],
    [ 'Roads', 'rds' ],
    [ 'Roadside', 'rdsd' ],
    [ 'Ronde', 'rnde' ],
    [ 'Rosebowl', 'rsbl' ],
    [ 'Rue', 'rue' ],
    [ 'Sound', 'snd' ],
    [ 'Stairs', 'strs' ],
    [ 'State highway', 'shwy' ],
    [ 'Thoroughfare', 'thor' ],
    [ 'Towers', 'twrs' ],
    [ 'Trailer', 'trlr' ],
    [ 'Triangle', 'tri' ],
    [ 'Trunkway', 'tkwy' ],
    [ 'Upper', 'upr' ],
    [ 'Viaduct', 'vdct' ],
    [ 'Villas', 'vlls' ],
    [ 'Wade', 'wade' ],
    [ 'Yard', 'yard' ]
  ]
end
