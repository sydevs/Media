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
  - **type** - one of

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
