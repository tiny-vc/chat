/// The server accept signal is authoritative, but it can arrive before the
/// outgoing call page subscribes. A connected LiveKit peer is equivalent proof
/// that the recipient accepted and received a room token.
bool shouldConfirmCallAcceptedFromPeer({
  required bool incoming,
  required bool accepted,
  required bool mediaConnected,
  required int remoteParticipantCount,
}) => !incoming && !accepted && mediaConnected && remoteParticipantCount > 0;
