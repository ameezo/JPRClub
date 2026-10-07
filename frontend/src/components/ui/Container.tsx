import React from 'react';

interface ContainerProps extends React.HTMLAttributes<HTMLDivElement> {
  children: React.ReactNode;
  className?: string;
}

export default function Container({ children, className = '', ...props }: ContainerProps) {
  return (
    <div className={`container-custom ${className}`} {...props}>
      {children}
    </div>
  );
}
