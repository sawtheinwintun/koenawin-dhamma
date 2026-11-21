/// YouTube videos shown on the Video tab.
class DhammaVideo {
  const DhammaVideo({required this.youtubeId, required this.title});

  final String youtubeId;
  final String title;

  String get thumbnailUrl =>
      'https://img.youtube.com/vi/$youtubeId/hqdefault.jpg';
}

enum VideoSession { morning, evening }

extension VideoSessionLabel on VideoSession {
  String get label => this == VideoSession.morning ? 'မနက်ပိုင်း' : 'ညနေပိုင်း';
}

/// Tapping a video plays it and then the rest of its session in order, then stops.
const videosBySession = {
  VideoSession.morning: [
    DhammaVideo(youtubeId: 'NWNmif7LgAY', title: 'ပရိတ်ကြီး၁၁သုတ်_ဦးဥတ္တမသာရ'),
    DhammaVideo(youtubeId: 'p44Fypo7JtI', title: 'မဟာသမယသုတ် ပါဠိတော်'),
  ],
  VideoSession.evening: [
    DhammaVideo(youtubeId: 'hbl-6R1DjGU', title: 'မဟာသမယသုတ် ပါဠိတော်'),
  ],
};
