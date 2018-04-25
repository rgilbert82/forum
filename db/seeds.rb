
ryan = User.create(username: 'Ryan', password: 'password', admin: true)
afx = User.create(username: 'user18081971', password: 'password')
cylob = User.create(username: 'cylob', password: 'password')
jlin = User.create(username: 'Jlin', password: 'password')
ceephax = User.create(username: 'ceephax', password: 'password')
squarepusher = User.create(username: 'andy_jenks', password: 'password')
vibert = User.create(username: 'luke_v', password: 'password')
paradinas = User.create(username: 'paradinas', password: 'password')
oneohtrix = User.create(username: 'oneohtrix', password: 'password')
eno = User.create(username: 'eno', password: 'password')
lustmord = User.create(username: 'lustmord', password: 'password')

analog = Forum.create(name: 'Analog Synths', user: ryan)
csound = Forum.create(name: 'Csound', user: ryan)
drum_machines = Forum.create(name: 'Drum Machines', user: ryan)
filters = Forum.create(name: 'Filters', user: ryan)
max = Forum.create(name: 'Max MSP', user: ryan)
microtonal = Forum.create(name: 'Microtonal Programming', user: ryan)
modular = Forum.create(name: 'Modular Synths', user: ryan)
osc = Forum.create(name: 'Oscillators', user: ryan)
pure_data = Forum.create(name: 'Pure Data', user: ryan)
sequencers = Forum.create(name: 'Sequencers and Trackers', user: ryan)
soft_synths = Forum.create(name: 'Software Synths', user: ryan)
supercollider = Forum.create(name: 'SuperCollider', user: ryan)
vintage = Forum.create(name: 'Vintage Gear', user: ryan)

Topic.create(title: 'Moog Voyager', body: 'great oscillators on this one, init?', forum: analog, user: afx)
Topic.create(title: 'TB 303', body: 'I can\'t live without it! Gotta have that acid!', forum: analog, user: ceephax)
Topic.create(title: 'new Korg Monologue', body: 'who is going to user this for lush microtonal tracks?', forum: analog, user: afx)
Topic.create(title: 'need Roland Juno ASAP', body: 'Where can I get one for under a thousand?', forum: analog, user: ryan)

Topic.create(title: 'granular opcodes', body: '\'fog\' is a good one', forum: csound, user: ryan)
Topic.create(title: 'Csound community', body: 'Am I the only one here?', forum: csound, user: ryan)

Topic.create(title: 'DS Tempest', body: 'This one will surely become a classic.', forum: drum_machines, user: ryan)
Topic.create(title: 'LinnDrum repair in London', body: 'I gotta get my LD pumping again! Help!', forum: drum_machines, user: vibert)
Topic.create(title: 'Korg MiniPops 35', body: 'great shaker, but tough to program', forum: drum_machines, user: afx)
Topic.create(title: 'TR 707', body: 'I need one of these for the Vibert gig in London. Can anybody help?', forum: drum_machines, user: ceephax)

Topic.create(title: 'highpass', body: 'high frequencies are for the weak', forum: filters, user: lustmord)

Topic.create(title: 'Does Autechre use Max?', body: 'I would like to know', forum: max, user: oneohtrix)
Topic.create(title: 'Jitter', body: 'Anybody know any good Jitter tutorials?', forum: max, user: oneohtrix)

Topic.create(title: 'SAW 2', body: 'I used custom scales for this one!', forum: microtonal, user: afx)
Topic.create(title: 'xenharmonic music the next big thing?', body: 'Check out \'The Quantum Loonyverse\'!', forum: microtonal, user: cylob)
Topic.create(title: 'SuperCollider microtonality', body: 'I made a 35-EDO track in SuperCollider! It\'s dope!', forum: microtonal, user: cylob)

Topic.create(title: 'Mod con', body: 'Pay me a lot of money so I can build a giant modular synth!!!', forum: modular, user: ryan)
Topic.create(title: 'Field Day EP', body: 'did u hear the EP I dropped at the London gig? all modular, mate.', forum: modular, user: afx)
Topic.create(title: 'OG mod', body: 'I was modular before it was cool, son.', forum: modular, user: eno)

Topic.create(title: 'VCO or DCO?', body: 'Or both?', forum: osc, user: paradinas)
Topic.create(title: 'stacking Csound oscils', body: 'You can make some pretty serious synths this way', forum: osc, user: ryan)

Topic.create(title: 'Does anybody use this?', body: 'Max Matthews designed it. It must be pretty cool!', forum: pure_data, user: oneohtrix)

Topic.create(title: 'Blue', body: 'Starting to get into the Blue sequencer for Csound. Steven Yi did a great job designing this!', forum: sequencers, user: ryan)
Topic.create(title: 'Renoise', body: 'A pretty good replacement for PlayerPro', forum: sequencers, user: afx)
Topic.create(title: 'Ableton', body: 'All the kids are using Live these days.', forum: sequencers, user: jlin)
Topic.create(title: 'PlayerPro', body: 'I made drukqs with tthis!', forum: sequencers, user: afx)

Topic.create(title: 'Quantum Loonyverse', body: 'Underrated album! Made with SC!', forum: supercollider, user: cylob)
Topic.create(title: 'RDJ album', body: 'I allegedly used supercollider to sequence the drums on this album...', forum: supercollider, user: afx)
Topic.create(title: 'Algorithmic Music', body: 'I\'m learning SC next!', forum: supercollider, user: ryan)

Topic.create(title: 'I own all the vintage gear', body: '...and you don\'t', forum: vintage, user: afx)
