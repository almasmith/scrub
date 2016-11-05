# scrub
A UI control for scrubbing through surveillance footage.

## Initial Thoughts
My initial thought was to simply implement the timeline as a single long view inside of a scrollview. I immediately saw some short-commings with this solution. Any changes to the data whether updating existing data or adding new data would require the entire timeline to be redrawn. While I don't believe the the length of the view for 30 days would be too memory intensive, it would be much bigger than needed, and it's not really a scalable solution. What if we wanted to scrub through a year, or 5 years? Also, if we wanted to change the way the view is drawn, it seemed this would take more work than necessary. Not a great solution.

## Collection View
My next thoughts were to implement the timeline as a series of segments. Each segment could be a small view that was only responsible for drawing a small portion of the timeline. This view would not need to be aware of any other views or any data not relevant to its small part of the timeline. These views would be lined up end to end in order to create the timeline. In this way we would only need to draw what is on the screen and could reuse the views to minimize our memory usage. It seemed to make sense that the best way to line up views and remove/reuse them would be to use a collection view and implement the views as collection view cells.

## Collection View Cell
Each cell should be given a segment of time. It should be able to draw the timeline, any events, and anything else that is needed. It should be be replaceable, meaning a future implementation of the cell can completely change the way that the timeline is drawn. Ideally the cell can be resized and redraw in order to zoom in/out.

## Data Transformation
I considered transforming the data that I received to something more consistent. There are trade-offs both to using data as is and transforming it to something the app dictates. I generally favor data transformation as I see it having more long term benefits. If the data the server provides changes in the future, you can just write a new transformation and the rest of the app can generally go unchanged.

In this case I thought about arranging the app data into 1 hour blocks with each block containing segments of recording times/gaps that make up that block. Having the data uniform in this way might facilitate the layout of the scrubber, allowing each cell to take a single block of time and be a uniform size. However, a drawback of data transformation is the upfront cost of transforming the data. Due to the time contstraints of the project I ultimately chose not to transform the data and consume it as is. This means that each cell will represent a recording segment or gap. Thus each cell will need to be a different size. The width of the cell will most likely be a function of the length of recording time/gap and some some point-per-hour contstant that I come up with. Changing that constant could allow me to zoom the timeline as well.

## Time Labels
The timeline has time labels at regular intervals so the user knows where they're at. In thinking about the problem of displaying these, I don't believe that the timeline cells should be responsible for them. They have the single responsibility of drawing out a timeline given a segment containing recording and event data. I'm not sure if suplementary views can be used to acheive what I want. I'll have to play with that idea and see if I can get them to work. Another idea I've had is to implement the time labels as a completely separate collection view and synchronize the scrolling between the two.

## Model
My preliminary thoughts on entities, influenced by my decision to use the data structured as is. I'm making the assumption that since an event is captured by a recording, that they cannot happen outside the context of a recording. Meaning that all events overlap with a recording and none of them overlap with gaps. I'm not sure if an event actually belongs to a recording, but it definitely feels like it should. Events have an "id" but recordings do not.

My thoughts bounce between handing a timeline cell a recording and a collection of events that happened during that recording, or to change the data structure a bit so that a recording contains a collection of events and just pass the recording to the cell. The logic to decide which events belong to which recordings will be the same whether I do that up front when processing the data or wait until passing it to a cell. I think it will be cleaner to express this in the model. So I guess I'm not leaving the data completely the way it is.

Also interesting is that despite a recording and an event being separate entities, they are extremely similar. The both have a camera and a start and end. Even though recording doesn't have a duration field, it still has a duration by it's very nature. The only difference it seems as that a recording can have events that happened during it. I wonder if events can have other events within them. If so, a recording and event are nearly the same entity.

The model could look like this:
protocol Device
  id: String
  name: String
  
protocol Recordable
  device: Device
  id: String
  startTime: Date
  endTime: Date
  duration: Double
  
protocol Eventful
  events: [Recordable]
  
class Camera: Device
class Recording: Recordable, Eventful
class Event: Recordable
  
I'm going to take some liberties with the sample data that I've been given. This is due to the fact that the data is coming in a way somewhat different than I'd expect from a web service. For example, the only association that a recording has to a camera is not in the data itself, but in the name of the file. If it actually does come this way in production, then I apologize.
