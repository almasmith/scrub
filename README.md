# scrub
A UI control for scrubbing through surveillance footage.

# Initial Thoughts
My initial thought was to simply implement the timeline as a single long view inside of a scrollview. I immediately saw some short-commings with this solution. Any changes to the data whether updating existing data or adding new data would require the entire timeline to be redrawn. While I don't believe the the length of the view for 30 days would be too memory intensive, it would be bigger than needed, and it's not really a scalable solution. What if we wanted to scrub through a year, or 5 years? Also, if we wanted to change the way the view is drawn, it seemed this would take more work than necessary. Not a great solution.

# Collection View
My next thoughts were to implement the timeline as a series of segments. Each segment could be a small view that was only responsible for drawing a small portion of the timeline. This view would not need to be aware of any other views or any data not relevant to its small part of the timeline. These views would be lined up end to end in order to create the timeline. In this way we would only need to draw what is on the screen and could reuse the views to minimize our memory usage. It seemed to make sense that the best way to line up views and remove/reuse them would be to use a collection view and implement the views as collection view cells.

# Collection View Cell
Each cell should be given a segment of time. It should be able to draw the timeline, any events, and anything else that is needed. It should be be replaceable, meaning a future implementation of the cell can completely change the way that the timeline is drawn. Ideally the cell can be resized and redraw in order to zoom in/out.
