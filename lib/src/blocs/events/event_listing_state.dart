abstract class EventListingState {}

class EventUninitializedState extends EventListingState {}

class EventFetchingState extends EventListingState {}

class EventFetchedAllState extends EventListingState {}

class EventErrorState extends EventListingState {}

class EventEmptyState extends EventListingState {}