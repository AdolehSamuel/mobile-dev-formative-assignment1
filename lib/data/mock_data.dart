import 'package:flutter/material.dart';

import '../models/chat_models.dart';
import '../models/club.dart';
import '../models/notification_item.dart';
import '../models/post.dart';
import '../models/user_profile.dart';

/// All mock/seed content for ALU Connect lives in this file. Dates are
/// generated relative to [DateTime.now] so the feed always looks current.
DateTime _at(int dayOffset, int hour, [int minute = 0]) {
  final now = DateTime.now();
  final day = DateTime(now.year, now.month, now.day);
  return day.add(Duration(days: dayOffset, hours: hour, minutes: minute));
}

/// Seed posts covering every [PostCategory] across all campuses.
List<Post> buildSeedPosts() => [
      Post(
        id: 'p1',
        title: 'AI for Social Impact Workshop',
        description:
            'Learn how AI tools can be used to drive social impact across '
            'Africa. Hands-on session with real datasets, followed by group '
            'projects mentored by the Tech & Innovation Hub team.',
        category: PostCategory.workshop,
        campus: Campus.mauritius,
        dateTime: _at(5, 9),
        location: 'Innovation Lab, Mauritius Campus',
        organizerName: 'Tech & Innovation Hub',
        organizerRole: UserRole.clubLeader,
        clubId: 'c4',
        coverThemeKey: 'tech',
        tags: const ['Workshop', 'Tech', 'AI'],
        goingCount: 48,
        interestedCount: 12,
      ),
      Post(
        id: 'p2',
        title: 'ALU Entrepreneurship Pitch Night',
        description:
            'Showcase your idea, get feedback from mentors, and connect with '
            'investors and fellow founders. Open to all campuses, finalists '
            'win seed funding and incubation support.',
        category: PostCategory.event,
        campus: Campus.kigali,
        dateTime: _at(2, 17),
        location: 'Auditorium, Kigali Campus',
        organizerName: 'Entrepreneurship Club',
        organizerRole: UserRole.clubLeader,
        clubId: 'c2',
        coverThemeKey: 'business',
        tags: const ['Pitch', 'Networking'],
        goingCount: 76,
        interestedCount: 30,
      ),
      Post(
        id: 'p3',
        title: 'Sustainable Solutions Challenge',
        description:
            'A continent-wide competition for student teams to pitch '
            'sustainability solutions for African cities. Top teams receive '
            'funding and a spot in the ALU Innovation Showcase.',
        category: PostCategory.opportunity,
        campus: Campus.online,
        dateTime: _at(10, 23, 59),
        location: 'Submit online, open to all campuses',
        organizerName: 'Career Development Office',
        organizerRole: UserRole.eventOrganizer,
        coverThemeKey: 'community',
        tags: const ['Competition', 'Sustainability'],
        deadline: _at(10, 23, 59),
        interestedCount: 22,
      ),
      Post(
        id: 'p4',
        title: 'Design Thinking Bootcamp',
        description:
            'A 2-day intensive bootcamp covering empathy mapping, ideation '
            'and rapid prototyping. Bring a problem you care about and leave '
            'with a tested prototype.',
        category: PostCategory.workshop,
        campus: Campus.kigali,
        dateTime: _at(6, 10),
        location: 'Innovation Lab, Kigali Campus',
        organizerName: 'Tech & Innovation Hub',
        organizerRole: UserRole.clubLeader,
        clubId: 'c4',
        coverThemeKey: 'tech',
        tags: const ['Bootcamp', 'Design'],
        goingCount: 34,
        interestedCount: 18,
      ),
      Post(
        id: 'p5',
        title: 'Community Clean-Up Drive',
        description:
            'Join fellow students for a morning of giving back to the '
            'community around campus. Gloves, bags and refreshments will be '
            'provided, just bring your energy!',
        category: PostCategory.event,
        campus: Campus.mauritius,
        dateTime: _at(1, 8),
        location: 'Main Gate, Mauritius Campus',
        organizerName: 'Sustainability & Climate Action Club',
        organizerRole: UserRole.clubLeader,
        clubId: 'c6',
        coverThemeKey: 'community',
        tags: const ['Volunteering', 'Environment'],
        goingCount: 41,
        interestedCount: 9,
      ),
      Post(
        id: 'p6',
        title: 'Campus Ambassador Program',
        description:
            'Represent ALU on social media and at local events. Ambassadors '
            'receive a stipend, exclusive merchandise, and leadership '
            'training. Open to students from all campuses.',
        category: PostCategory.opportunity,
        campus: Campus.online,
        dateTime: _at(12, 23, 59),
        location: 'Remote, all campuses',
        organizerName: 'Marketing & Communications Office',
        organizerRole: UserRole.eventOrganizer,
        coverThemeKey: 'leadership',
        tags: const ['Leadership', 'Paid'],
        deadline: _at(12, 23, 59),
        interestedCount: 64,
      ),
      Post(
        id: 'p7',
        title: 'ALU Climate Action Week',
        description:
            'A week of talks, workshops and a campus-wide clean-up focused '
            'on climate resilience in Africa, running simultaneously across '
            'Kigali and Mauritius campuses.',
        category: PostCategory.event,
        campus: Campus.online,
        dateTime: _at(8, 9),
        location: 'Kigali & Mauritius Campuses',
        organizerName: 'Sustainability & Climate Action Club',
        organizerRole: UserRole.clubLeader,
        clubId: 'c6',
        coverThemeKey: 'community',
        tags: const ['Climate', 'Week-long'],
        goingCount: 120,
        interestedCount: 55,
      ),
      Post(
        id: 'p8',
        title: 'Build Your First MVP Workshop',
        description:
            'From idea to working prototype in one weekend. We will cover '
            'no-code tools, basic Flutter setup, and how to validate your '
            'idea with real users.',
        category: PostCategory.workshop,
        campus: Campus.kigali,
        dateTime: _at(4, 13),
        location: 'Hackerspace, Kigali Campus',
        organizerName: 'ALU Devs (Coding Club)',
        organizerRole: UserRole.clubLeader,
        clubId: 'c7',
        coverThemeKey: 'tech',
        tags: const ['Coding', 'Startup'],
        goingCount: 29,
        interestedCount: 14,
      ),
      Post(
        id: 'p9',
        title: 'Calculus II Midterm Study Group',
        description:
            'Peer-led study session covering integration techniques and '
            'series from the last two weeks. All welcome, bring your '
            'practice problems!',
        category: PostCategory.studyGroup,
        campus: Campus.kigali,
        dateTime: _at(1, 18),
        location: 'Library, Room 204, Kigali Campus',
        organizerName: 'Aline Umuhoza',
        organizerRole: UserRole.student,
        coverThemeKey: 'academics',
        tags: const ['Study Group', 'Math'],
        goingCount: 8,
        interestedCount: 5,
      ),
      Post(
        id: 'p10',
        title: 'Library Extended Hours for Finals Week',
        description:
            'The library will be open 24/7 across all campuses during '
            'finals week, with extra quiet study zones and free coffee '
            'after 10pm.',
        category: PostCategory.announcement,
        campus: Campus.online,
        dateTime: _at(0, 9),
        location: 'All Campuses',
        organizerName: 'Academic Affairs Office',
        organizerRole: UserRole.academicRep,
        coverThemeKey: 'academics',
        tags: const ['Academics', 'Finals'],
      ),
      Post(
        id: 'p11',
        title: 'Data Analyst Internship, Kigali Innovation City',
        description:
            'A 3-month paid internship working with the analytics team at '
            'Kigali Innovation City. Open to second and third year students '
            'with strong Excel/SQL skills.',
        category: PostCategory.opportunity,
        campus: Campus.kigali,
        dateTime: _at(15, 23, 59),
        location: 'Kigali, Rwanda (Hybrid)',
        organizerName: 'Career Development Office',
        organizerRole: UserRole.eventOrganizer,
        coverThemeKey: 'business',
        tags: const ['Internship', 'Data'],
        deadline: _at(15, 23, 59),
        interestedCount: 37,
      ),
      Post(
        id: 'p12',
        title: 'ALU Leadership Summit 2026',
        description:
            'A flagship cross-campus summit featuring alumni founders, '
            'policymakers and student leaders. Streamed live to all campuses '
            'with in-person tracks in Mauritius.',
        category: PostCategory.event,
        campus: Campus.online,
        dateTime: _at(14, 9),
        location: 'Mauritius Campus + Livestream',
        organizerName: 'Student Leadership Council',
        organizerRole: UserRole.eventOrganizer,
        coverThemeKey: 'leadership',
        tags: const ['Leadership', 'Summit'],
        goingCount: 200,
        interestedCount: 88,
      ),
      Post(
        id: 'p13',
        title: 'Public Speaking Masterclass',
        description:
            'Sharpen your public speaking and debate skills with practical '
            'exercises and feedback from the ALU Debate Society\'s top '
            'ranked speakers.',
        category: PostCategory.workshop,
        campus: Campus.mauritius,
        dateTime: _at(3, 16),
        location: 'Room B12, Mauritius Campus',
        organizerName: 'ALU Debate Society',
        organizerRole: UserRole.clubLeader,
        clubId: 'c1',
        coverThemeKey: 'social',
        tags: const ['Public Speaking'],
        goingCount: 22,
        interestedCount: 11,
      ),
      Post(
        id: 'p14',
        title: 'HealthTech for Africa Hackathon',
        description:
            '48 hours to design and prototype a digital health solution for '
            'underserved communities. Mentors from leading African health-tech '
            'startups will be on-site.',
        category: PostCategory.event,
        campus: Campus.kigali,
        dateTime: _at(9, 9),
        location: 'Innovation Lab, Kigali Campus',
        organizerName: 'Tech & Innovation Hub',
        organizerRole: UserRole.clubLeader,
        clubId: 'c4',
        coverThemeKey: 'tech',
        tags: const ['Hackathon', 'HealthTech'],
        goingCount: 64,
        interestedCount: 40,
      ),
    ];

/// Seed clubs / communities across categories and campuses.
List<Club> buildSeedClubs() => const [
      Club(
        id: 'c1',
        name: 'ALU Debate Society',
        description:
            'Weekly debates, public speaking drills and inter-campus '
            'tournaments. Open to all years and confidence levels.',
        category: 'Leadership & Speaking',
        campus: Campus.mauritius,
        icon: Icons.record_voice_over_rounded,
        color: Color(0xFFEF6F8E),
        memberCount: 124,
      ),
      Club(
        id: 'c2',
        name: 'Entrepreneurship Club',
        description:
            'A community for student founders, with pitch practice, mentorship '
            'matching, and a pipeline into ALU\'s startup incubator.',
        category: 'Entrepreneurship',
        campus: Campus.kigali,
        icon: Icons.rocket_launch_rounded,
        color: Color(0xFF8C7CF6),
        memberCount: 250,
      ),
      Club(
        id: 'c3',
        name: 'Women in Leadership',
        description:
            'Mentorship circles, leadership workshops and a cross-campus '
            'network for women navigating leadership at ALU and beyond.',
        category: 'Leadership',
        campus: Campus.online,
        icon: Icons.workspace_premium_rounded,
        color: Color(0xFFF5A623),
        memberCount: 180,
      ),
      Club(
        id: 'c4',
        name: 'Tech & Innovation Hub',
        description:
            'Workshops, hackathons and study sessions on AI, software and '
            'product design, from beginner to advanced.',
        category: 'Tech & Innovation',
        campus: Campus.mauritius,
        icon: Icons.memory_rounded,
        color: Color(0xFF5B9CF6),
        memberCount: 210,
      ),
      Club(
        id: 'c5',
        name: 'Travel Buddies',
        description:
            'Planning weekend trips, cultural excursions and travel deals '
            'for students exploring Rwanda and Mauritius.',
        category: 'Social & Culture',
        campus: Campus.online,
        icon: Icons.flight_takeoff_rounded,
        color: Color(0xFF36C2CE),
        memberCount: 95,
      ),
      Club(
        id: 'c6',
        name: 'Sustainability & Climate Action Club',
        description:
            'Campus clean-ups, climate advocacy and sustainability projects '
            'across both campuses.',
        category: 'Community & Environment',
        campus: Campus.mauritius,
        icon: Icons.eco_rounded,
        color: Color(0xFF4ADE80),
        memberCount: 140,
      ),
      Club(
        id: 'c7',
        name: 'ALU Devs (Coding Club)',
        description:
            'Build real projects together, with weekly coding sessions, code '
            'reviews and an annual student hackathon.',
        category: 'Tech & Innovation',
        campus: Campus.kigali,
        icon: Icons.code_rounded,
        color: Color(0xFF5B9CF6),
        memberCount: 175,
      ),
      Club(
        id: 'c8',
        name: 'African Culture & Heritage Crew',
        description:
            'Celebrating the continent\'s cultures through food, music and '
            'storytelling nights, a home away from home.',
        category: 'Social & Culture',
        campus: Campus.kigali,
        icon: Icons.festival_rounded,
        color: Color(0xFFF5A623),
        memberCount: 160,
      ),
    ];

/// Seed conversations. `isMe: true` messages represent the signed-in user.
List<Conversation> buildSeedConversations() => [
      Conversation(
        id: 'conv1',
        title: 'AI Workshop Group',
        subtitle: '32 members',
        icon: Icons.memory_rounded,
        color: const Color(0xFF5B9CF6),
        isGroup: true,
        clubId: 'c4',
        messages: [
          ChatMessage(
            id: 'm1',
            senderName: 'Fatima Hassan',
            text:
                "Hey team! Don't forget our session tomorrow at 9am. See you there!",
            timestamp: DateTime.now().subtract(const Duration(hours: 5)),
            isMe: false,
          ),
          ChatMessage(
            id: 'm2',
            senderName: 'David Kintu',
            text: "Got it! I'll bring my laptop.",
            timestamp:
                DateTime.now().subtract(const Duration(hours: 4, minutes: 50)),
            isMe: false,
          ),
          ChatMessage(
            id: 'm3',
            senderName: 'You',
            text: "Can't wait!",
            timestamp:
                DateTime.now().subtract(const Duration(hours: 4, minutes: 40)),
            isMe: true,
          ),
          ChatMessage(
            id: 'm4',
            senderName: 'Jean Paul',
            text: 'Shared the workshop materials in the drive folder.',
            timestamp:
                DateTime.now().subtract(const Duration(hours: 4, minutes: 30)),
            isMe: false,
          ),
        ],
      ),
      Conversation(
        id: 'conv2',
        title: 'Entrepreneurship Club',
        subtitle: '250 members',
        icon: Icons.rocket_launch_rounded,
        color: const Color(0xFF8C7CF6),
        isGroup: true,
        clubId: 'c2',
        messages: [
          ChatMessage(
            id: 'm5',
            senderName: 'David',
            text: "Don't forget the meeting at 5pm today!",
            timestamp: DateTime.now().subtract(const Duration(hours: 22)),
            isMe: false,
          ),
          ChatMessage(
            id: 'm6',
            senderName: 'Grace M.',
            text: 'Pitch deck template is up, check the pinned message.',
            timestamp: DateTime.now().subtract(const Duration(hours: 20)),
            isMe: false,
          ),
        ],
      ),
      Conversation(
        id: 'conv3',
        title: 'Campus Leaders',
        subtitle: '18 members',
        icon: Icons.groups_rounded,
        color: const Color(0xFFF5A623),
        isGroup: true,
        messages: [
          ChatMessage(
            id: 'm7',
            senderName: 'Jean',
            text: 'See you all there!',
            timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
            isMe: false,
          ),
        ],
      ),
      Conversation(
        id: 'conv4',
        title: 'Travel Buddies',
        subtitle: '95 members',
        icon: Icons.flight_takeoff_rounded,
        color: const Color(0xFF36C2CE),
        isGroup: true,
        clubId: 'c5',
        messages: [
          ChatMessage(
            id: 'm8',
            senderName: 'Sarah K.',
            text: 'Any updates on the weekend trip to Lake Kivu?',
            timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
            isMe: false,
          ),
        ],
      ),
      Conversation(
        id: 'conv5',
        title: 'ALU Debate Society',
        subtitle: '124 members',
        icon: Icons.record_voice_over_rounded,
        color: const Color(0xFFEF6F8E),
        isGroup: true,
        clubId: 'c1',
        messages: [
          ChatMessage(
            id: 'm9',
            senderName: 'Emmanuel',
            text: 'Great job at finals everyone!',
            timestamp: DateTime.now().subtract(const Duration(days: 2)),
            isMe: false,
          ),
        ],
      ),
      Conversation(
        id: 'conv6',
        title: 'Fatima Hassan',
        subtitle: 'Tech & Innovation Hub',
        icon: Icons.person_rounded,
        color: const Color(0xFF36C2CE),
        isGroup: false,
        messages: [
          ChatMessage(
            id: 'm10',
            senderName: 'Fatima Hassan',
            text: 'Hi! Are you joining the AI workshop this week?',
            timestamp: DateTime.now().subtract(const Duration(hours: 6)),
            isMe: false,
          ),
          ChatMessage(
            id: 'm11',
            senderName: 'You',
            text: "Yes! Just RSVP'd",
            timestamp: DateTime.now().subtract(const Duration(hours: 5, minutes: 50)),
            isMe: true,
          ),
        ],
      ),
    ];

/// Seed notifications for the Notifications center.
List<NotificationItem> buildSeedNotifications() => [
      NotificationItem(
        id: 'n1',
        type: NotificationType.rsvp,
        title: 'Reminder: Community Clean-Up Drive',
        body: "Don't forget your gloves! Meet at the Main Gate, 8:00 AM.",
        time: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      NotificationItem(
        id: 'n2',
        type: NotificationType.message,
        title: 'New message in AI Workshop Group',
        body: 'Jean Paul: Shared the workshop materials in the drive folder.',
        time: DateTime.now().subtract(const Duration(hours: 4, minutes: 30)),
      ),
      NotificationItem(
        id: 'n3',
        type: NotificationType.club,
        title: 'Entrepreneurship Club',
        body: 'Pitch Night registration is now open, RSVP before slots fill up!',
        time: DateTime.now().subtract(const Duration(hours: 9)),
      ),
      NotificationItem(
        id: 'n4',
        type: NotificationType.club,
        title: 'Tech & Innovation Hub',
        body: 'New workshop posted: Build Your First MVP Workshop.',
        time: DateTime.now().subtract(const Duration(hours: 20)),
      ),
      NotificationItem(
        id: 'n5',
        type: NotificationType.system,
        title: 'Library Extended Hours',
        body:
            'The library is open 24/7 across all campuses during finals week.',
        time: DateTime.now().subtract(const Duration(days: 1, hours: 1)),
      ),
      NotificationItem(
        id: 'n6',
        type: NotificationType.system,
        title: 'Welcome to ALU Connect!',
        body: 'Complete your profile to get personalized recommendations.',
        time: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
