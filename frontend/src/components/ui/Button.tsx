import React from 'react';

interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  children: React.ReactNode;
  variant?: 'primary' | 'secondary' | 'outline';
  size?: 'sm' | 'md' | 'lg';
  className?: string;
  as?: React.ElementType;
  to?: string;
}

export default function Button({
  children,
  variant = 'primary',
  size = 'md',
  className = '',
  as: Component = 'button',
  ...props
}: ButtonProps) {
  return (
    <Component
      className={`btn-base btn-${variant} btn-${size} ${className}`}
      {...props}
    >
      {children}
    </Component>
  );
}
