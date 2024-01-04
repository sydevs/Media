- [Display Endpoints](#display-endpoints)
  - [Meditation Data: `/meditations/<id>.json`](#meditation-data-meditationsidjson)
  - [Homepage Feed: `/users/<external_id>.json?time=<time>`](#homepage-feed-usersexternal_idjsontimetime)
  - [Track User Event: `/users/<external_id>/track`](#track-user-event-usersexternal_idtrack)
- [Homepage Feed Content](#homepage-feed-content)
  - [Feature Sections](#feature-sections)
  - [Action Sections](#action-sections)
  - [Category Sections](#category-sections)

## Display Endpoints
### Meditation Data: `/meditations/<id>.json`
#### Parameters <!-- omit in toc -->
- METHOD: `GET`
- **id** - unique identifier for this meditation

#### JSON Response <!-- omit in toc -->
- **id**
- **title**
- **audio_url**
- **narrator** - "male" or "female"
- **musics** - an array of possible `music` objects for this meditation:
  - **title**
  - **credit** - the musician's name
  - **url** - audio file for the music track
- **frames** - an array of `frame` objects, which represent still images or video files that make up the meditation:
  - **id**
  - **seconds** - the number of seconds into the meditation when this frame should be shown
  - **type** - "video" or "image"
  - **frame** - url for the video or image file


### Homepage Feed: `/users/<external_id>.json?time=<time>`
#### Parameters <!-- omit in toc -->
- METHOD: `GET`
- **external_id** - the user identifier used in the We Meditate app or other client application. The server has it's own internal user ID, which you don't need to worry about.
- **time** - an encoded datetime string with timezone information. This should be the local time of the user, this is used to determine what meditations to return.

#### JSON Response <!-- omit in toc -->
If any section has `disabled=true` then it should appear greyed out, and not be selectable.
- An array of sections, each section is a hash with the following structure
  - **header**
  - **type** - `featured`, `action`, or `list`
  - **disabled** - `true` or `false`
  - **cards** - an array of `card`` objects:
    - **title**
    - **subtitle**
    - **image_url**
    - **link_type** - `app` or `web`
    - **link** - Will be an http url if `link_type=web` or a page name if `link_type=app`
    - **meditation_id** (optional) - the meditation id if `link=PlayerPage`
    - **duration** (optional) - the meditation duration in minutes if `link=PlayerPage`
    - **countdown** (optional) - a UTC time. This is used when the card is linking to an event which either starts or ends at the countdown time.


### Track User Event: `/users/<external_id>/track`
#### Parameters <!-- omit in toc -->
- METHOD: `POST`
- **external_id** - the user identifier used in the We Meditate app or other client application. The server has it's own internal user ID, which you don't need to worry about.
- **events** - an array of `event` objects:
  - **type** - one of `save`, `unsave`, `meditation`, `seen`, `unlock`, `path`
    - A `save` or `unsave` event will add/remove a meditation from the user's list of saved meditations. This list is displayed at the bottom of their homepage feed.
    - A `meditation` event tracks when a user watches a meditation. If possible you should also provide the `progress` and `rating` to give us more information that recommendations could be based on in the future.
    - A `seen` event lets us know what parts of the app the user has already seen, you should provide the `flag` field to tell us which part to mark as "seen"
    - An `unlock` event tells the server to unlock a new category of meditations for the user. Most important for the moment is that after the user watches the "First Meditation" you must unlock the `realisation` flag to enable all other meditations.
    - A `path` event tracks progress on the path. This helps us know whether to tell the user to "start" or "continue" on the path. It also can be used to suggest silent meditations or in-person meditations when they are further on the path.
    - There is no way to "unsee" or "lock" things which have been "seen" or "unlocked"
  - **meditation_id** - required if type= `save`, `unsave`, or `meditation`
  - **flag** - which flag to set
    - if type=`seen`, this should be one of `realisation`, `path`, `music`, `introspect`, `map`
    - if type=`unlock`, this should be one of `realisation`, `footsoak`, `lectures`
  - **progress**
    - if type=`meditation`, an integer from 0 - 100, indicating what percentage of the meditation was watched
    - if type=`path`, the number of path modules that the user has completed
  - **rating** - if type=`meditation`

#### JSON Response <!-- omit in toc -->
- **status** - an http status code
- **message** - details about any error
- **data** - user data:
  - **external_id**
  - **seen** - flags of things the user has seen
  - **unlocked** - flags of things the user has unlocked
  - **path_progress** - current path progress level
  - **path_progressed_at** - the last time the user progressed on the path

## Homepage Feed Content
Here is the current logic for what appears on the homepage feed. There will always be a single "Featured" section, 1 or more "Action" sections, and 1 or more "Category" sections.

### Feature Sections
- **The first meditation** if that has not already been completed. If this is chosen, then all other sections will be marked as disabled and there will be no other feature sections.
- **Live meditation** if a live meditation is starting in the next hour. The tailored meditation will also be shown below.
- **Tailored meditation** based on the time of day.

### Action Sections
- **Start Path** if the path has not been started
- **Continue Path** if the user has started the path, but not progressed in 3+ days.
- **Music page** if the user has completed 10 - 19 path lessons.
- **Atlas page** (on wemeditate.com for now) if the user has completed 20+ path lessons.

### Category Sections
- **Quick meditations** a random set of meditations which are in the 5 - 10 minute window. Shown on weekday mornings only.
- **Meditations for morning/afternoon/evening** 3 random meditations related to the time day (not shown on weekday mornings)
- **Recommended meditations** (currently disabled) if the database has tracked 20+ meditation views for the user.
- **Music-focused meditations** if it is a weekend (music-focused meditations can also appear in other categories)
