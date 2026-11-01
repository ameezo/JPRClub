import Hero from './Hero';
import CommunityStats from './CommunityStats';
import RecentSessions from './RecentSessions';
import Gallery from './Gallery';

export default function HomePage() {
  return (
    <>
      <Hero />
      <CommunityStats />
      <RecentSessions />
      <Gallery />
    </>
  );
}
